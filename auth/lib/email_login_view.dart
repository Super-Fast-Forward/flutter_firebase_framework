import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView({super.key});

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Failed to sign in with Email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Log in to continue",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _LoginTextField(
            header: "Email",
            controller: emailController,
          ),
          const SizedBox(
            height: 20,
          ),
          _LoginTextField(
            header: "Password",
            controller: passwordController,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              signInWithEmail(emailController.text, passwordController.text);
            },
            child: Container(
              color: Colors.purple,
              child: const Text("Log In"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Text(
              "Reset your password",
              style: TextStyle(color: Colors.purple),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.header,
    required this.controller,
  });

  final String header;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(header),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
