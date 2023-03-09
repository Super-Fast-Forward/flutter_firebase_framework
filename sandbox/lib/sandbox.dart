import 'package:flutter/material.dart';

class Sandbox extends StatelessWidget {
  final Widget? child;
  final Function()? toggle;
  const Sandbox({this.child, this.toggle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Column(
              children: [
                child ?? Container(),
                ElevatedButton(onPressed: toggle, child: Text('Toggle'))
              ],
            )));
  }
}
