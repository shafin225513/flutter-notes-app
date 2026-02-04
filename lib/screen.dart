import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notes_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool isLoading = false; // show loader during login

  Future<void> login() async {
    setState(() {
      isLoading = true;
      message = '';
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesScreen()),
      );

      setState(() {
        message = 'Login successful ✅';
      });
    } catch (e) {
      setState(() {
        message = 'Login failed ❌';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.note_alt, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // You can add navigation to signup here later
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
