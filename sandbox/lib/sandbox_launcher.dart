import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is an overlay frame for debugging individual widgets
/// Unfortunately it updates on every click on the textedit field
/// or key entry. Hence, let's not use it as overlay.
class SandboxLauncher extends StatefulWidget {
  final Widget app;
  final Widget sandbox;
  final Function(bool state)? saveState;
  final Function()? getInitialState;

  const SandboxLauncher(
      {Key? key,
      required this.app,
      required this.sandbox,
      this.getInitialState,
      this.saveState})
      : super(key: key);

  @override
  State<SandboxLauncher> createState() => _SandboxLauncherState();
}

class _SandboxLauncherState extends State<SandboxLauncher> {
  bool _isSandbox = false;

  @override
  void initState() {
    super.initState();
    if (widget.getInitialState != null) {
      widget.getInitialState!().then((value) {
        if (value != null && value != null) {
          setState(() {
            _isSandbox = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        // print(
        //     'Ctrl Right: ${RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.metaRight)}, Ctrl Left: ${RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.metaLeft)}');
        if (RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaRight) &&
            RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaLeft)) {
          print('sandbox will be shown/hidden');
          // sandbox will be shown/hidden on Left and Right Ctrl pressed at the
          // same time
          if (widget.saveState != null) {
            widget.saveState!(!_isSandbox);
          }
          setState(() {
            _isSandbox = !_isSandbox;
          });
        }
      },
      child: _isSandbox ? widget.sandbox : widget.app);
}
