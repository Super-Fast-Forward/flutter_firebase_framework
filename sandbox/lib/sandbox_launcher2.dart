import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandbox/sandbox.dart';

/// This is an overlay frame for debugging individual widgets
/// Unfortunately it updates on every click on the textedit field
/// or key entry. Hence, let's not use it as overlay.
class SandboxLauncher2 extends StatefulWidget {
  final Widget app;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Widget sandbox;
  final Function(bool state)? saveState;
  final Function()? getInitialState;
  final Function()? toggleState;
  final Stream<bool>? feedState;
  final bool enabled;

  const SandboxLauncher2(
      {Key? key,
      required this.app,
      required this.sandbox,
      this.themeMode,
      this.theme,
      this.darkTheme,
      this.getInitialState,
      this.saveState,
      this.toggleState,
      this.feedState,
      this.enabled = true})
      : super(key: key);

  @override
  State<SandboxLauncher2> createState() => _SandboxLauncherState2();
}

class _SandboxLauncherState2 extends State<SandboxLauncher2> {
  bool _isSandbox = false;

  @override
  void initState() {
    super.initState();
    if (widget.getInitialState != null && widget.feedState == null) {
      widget.getInitialState!().then((value) {
        if (value != null) {
          print('initial state received, call setState with: ${value}');
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
        if (this.widget.enabled == false) {
          print('sandbox is not enabled. Skip toggle.');
          return;
        }
        if (RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaRight) &&
            RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaLeft) &&
            RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.controlLeft) &&
            RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.controlRight)) {
          try {
            // sandbox will be shown/hidden on Left and Right Ctrl pressed at the
            // same time
            print('Cmd+Cmd pressed, call toggle');

            toggle();
          } catch (e) {
            print('Error: $e');
          }
        }
      },
      child: !widget.enabled
          ? widget.app
          : (widget.feedState != null
              ? StreamBuilder<bool>(
                  stream: widget.feedState,
                  builder: (context, snapshot) {
                    print('build with StreamBuilder with ${_isSandbox}');
                    if (widget.toggleState == null) {
                      _isSandbox = snapshot.hasData && snapshot.data == true;
                    }
                    return snapshot.hasData && snapshot.data == true
                        ? widget.sandbox
                        : widget.app;
                  })
              : (_isSandbox ? widget.sandbox : widget.app)));

  void toggle() {
    print('toggle sandbox');
    if (widget.saveState != null) {
      print('save state: ${!_isSandbox}');
      widget.saveState!(!_isSandbox);
    }
    if (widget.feedState == null) {
      print('call setState with: ${!_isSandbox}');
      setState(() {
        _isSandbox = !_isSandbox;
      });
    }
    if (widget.toggleState != null) {
      print('toggle state');
      widget.toggleState!();
    }
  }
}
