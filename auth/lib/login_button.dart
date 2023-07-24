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
    if (isVisible) return const SizedBox.shrink();
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black, width: 0.3),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black,
                    width: 0.3,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(icon),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
