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
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _submitPost, child: Text('Post')),
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
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.body),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Delete Post'),
                                      content: Text(
                                        'Are you sure you want to delete this post?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    bool success = await _postService
                                        .deletePost(post.id!);

                                    if (success) {
                                      setState(() {
                                        _postsFuture = _postService.getPosts();
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Post deleted successfully',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
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
