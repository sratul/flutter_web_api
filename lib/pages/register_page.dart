import 'package:flutter/material.dart';
import 'package:flutter_web_api/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _handleRegister() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    bool result = await _authService.register(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() {
      _loading = false;
      if (result) {
        _successMessage = "Registration successful! You can now log in.";
      } else {
        _errorMessage =
            "Registration failed. Try a different email or stronger password.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 24),
            if (_loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _handleRegister,
                child: const Text("Register"),
              ),
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}
