import 'package:flutter/material.dart';

class Sandbox extends StatelessWidget {
  final Widget? child;
  const Sandbox({this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: child ?? Container()));
  }
}
