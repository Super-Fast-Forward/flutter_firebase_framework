import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandbox/sandbox.dart';

/// This is an overlay frame for debugging individual widgets
/// Unfortunately it updates on every click on the textedit field
/// or key entry. Hence, let's not use it as overlay.
class SandboxLauncher extends StatefulWidget {
  final Widget app;
  final Widget sandbox;
  final Function(bool state)? saveState;
  final Function()? getInitialState;
  final Stream<bool>? feedState;

  const SandboxLauncher(
      {Key? key,
      required this.app,
      required this.sandbox,
      this.getInitialState,
      this.saveState,
      this.feedState})
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
        if (value != null) {
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
        if (RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaRight) &&
            RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaLeft)) {
          // sandbox will be shown/hidden on Left and Right Ctrl pressed at the
          // same time
          toggle();
        }
      },
      child: _isSandbox
          ? Sandbox(child: widget.sandbox, toggle: toggle)
          : widget.app);

  void toggle() {
    print('toggle sandbox');
    if (widget.saveState != null) {
      widget.saveState!(!_isSandbox);
    }
    setState(() {
      _isSandbox = !_isSandbox;
    });
  }
}
