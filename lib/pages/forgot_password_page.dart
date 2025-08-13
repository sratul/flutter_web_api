import 'package:flutter/material.dart';
import 'package:flutter_web_api/post_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final PostService postService = PostService();
  bool _isLoading = false;

  void _submit() async {
    setState(() => _isLoading = true);

    // Call you backend API
    final success = await postService.sendForgotPassword(
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    final message = success
        ? "Password reset instructions sent to your email."
        : "Failed to send reset instructions.";

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Your email"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text("Send reset email"),
                  ),
          ],
        ),
      ),
    );
  }
}
