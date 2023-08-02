import 'package:auth/main.dart';
import 'package:auth/toast.dart';
import 'package:auth/utils/firebase_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailLoginView extends ConsumerWidget {
  const EmailLoginView({super.key});

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          Toast.showError(getFirebaseMessageFromErrorCode(e.code));
        }
      } else {
        Toast.showError(getFirebaseMessageFromErrorCode(e.code));
      }
    } catch (e) {
      Toast.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return SizedBox(
      width: 430,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Log in to continue",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            height: 47,
          ),
          _LoginTextField(
            header: "Email",
            controller: emailController,
          ),
          const SizedBox(
            height: 25,
          ),
          _LoginTextField(
            header: "Password",
            obscureText: true,
            controller: passwordController,
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              signUpWithEmail(
                email: emailController.text,
                password: passwordController.text,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 60, 12, 234),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 0.3),
              ),
              height: 60,
              alignment: Alignment.center,
              width: double.maxFinite,
              child: const Text(
                "Log In",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          GestureDetector(
            child: const Text(
              "Reset your password",
              style: TextStyle(
                fontSize: 19,
                color: Color.fromARGB(255, 60, 12, 234),
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          GestureDetector(
            onTap: () {
              ref.read(openEmailLogin.notifier).value = false;
              ref.read(openEmailSignIn.notifier).value = false;
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 19,
                color: Color.fromARGB(255, 60, 12, 234),
              ),
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
    this.obscureText = false,
  });

  final String header;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }
}
