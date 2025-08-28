import 'package:flutter/material.dart';
import 'package:flutter_web_api/post.dart';
import 'package:flutter_web_api/post_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  bool _isLoading = false;
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  void _submitPost() async {
    setState(() => _isLoading = true);

    Post? post = await _postService.createPost(
      _titleController.text,
      _bodyController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (post != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post created successfully!')));
      _titleController.clear();
      _bodyController.clear();
      _postsFuture = _postService.getPosts();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create post')));
    }
  }

  void _showEditDialog(BuildContext context, Post post) {
    TextEditingController titleController = TextEditingController(
      text: post.title,
    );
    TextEditingController bodyController = TextEditingController(
      text: post.body,
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                bool success = await _postService.updatePost(
                  post.id!,
                  titleController.text.trim(),
                  bodyController.text.trim(),
                );
                if (success) {
                  setState(() {
                    _postsFuture = _postService.getPosts();
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Post Updated!!')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCommentDialog(
    BuildContext context,
    String postId,
    String commentId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Comment'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bool success = await _postService.deleteComment(postId, commentId);
      if (success) {
        setState(() {
          _postsFuture = _postService.getPosts(); // refresh posts and comments
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Comment deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You do not have permission to delete this comment'),
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, Post post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      bool success = await _postService.deletePost(post.id!);

      if (success) {
        setState(() {
          _postsFuture = _postService.getPosts();
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You dont have permission to delete')),
        );
      }
    }
  }

  void _showCommentDialog(BuildContext context, Post post) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add a Comment?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Comment'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                final newComment = await _postService.postComment(
                  post,
                  commentController.text.trim(),
                );
                Navigator.pop(ctx);
                if (newComment != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('You commented')));
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Comment failed.')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _postsFuture = _postService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create a Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // TextField(
                    //   controller: _titleController,
                    //   decoration: InputDecoration(labelText: 'Title'),
                    // ),
                    // const SizedBox(height: 10),
                    TextField(
                      controller: _bodyController,
                      decoration: InputDecoration(labelText: 'Body'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submitPost,
                            child: Text('Post'),
                          ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts available.'));
                  } else {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, postIndex) {
                        final post = posts[postIndex];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    post.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(post.body),
                                      Text(post.userId),
                                      IconButton(
                                        onPressed: () async {
                                          final newCount = await _postService
                                              .likePost(post.id!);
                                          if (newCount != null) {
                                            setState(() {
                                              post.likeCount = newCount;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.thumb_up),
                                      ),
                                      Text('${post.likeCount}'),
                                      IconButton(
                                        onPressed: () {
                                          _showCommentDialog(context, post);
                                        },
                                        icon: Icon(Icons.comment),
                                      ),
                                      post.comments.isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: post.comments.length,
                                              itemBuilder: (context, commentIndex) {
                                                // if (index == 0) {
                                                //   return null;
                                                // }
                                                final comment =
                                                    post.comments[commentIndex];
                                                return ListTile(
                                                  leading: Icon(Icons.comment),
                                                  title: Text(comment.body),
                                                  subtitle: Text(
                                                    'By user: ${comment.userId}  ${comment.createdAt != null ? comment.createdAt?.toLocal().toIso8601String() : ""}',
                                                  ),
                                                  trailing:
                                                      currentUserIsAuthorized
                                                      ? IconButton(
                                                          onPressed: () {
                                                            _showDeleteCommentDialog(
                                                              context,
                                                              post.id!,
                                                              comment.id!,
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                          ),
                                                        )
                                                      : null,
                                                );
                                              },
                                            )
                                          : Text('No comments'),
                                      Text('Comments: ${post.comments.length}'),
                                    ],
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(context, post);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          _showDeleteDialog(context, post);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
