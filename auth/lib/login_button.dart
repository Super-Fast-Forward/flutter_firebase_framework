import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.padding,
    this.isVisible = true,
  });

  final bool isVisible;
  final String text;
  final String icon;
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Color.fromARGB(255, 208, 208, 208),
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(right: 50),
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox.square(
                  dimension: 30,
                  child: SvgPicture.asset(icon, fit: BoxFit.contain),
                ),
              ),
              SizedBox(width: 180, child: Text(text)),
            ],
          ),
        ),
      ),
    );
  }
}
