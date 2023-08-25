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
    if (!isVisible) return const SizedBox.shrink();
    return Container(
      height: 47,
      width: 309,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1D1C2A),
          width: 0.3,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 23,
              child: SvgPicture.asset(icon),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1D1C2A),
                fontSize: 16,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
