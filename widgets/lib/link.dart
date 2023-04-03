import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

const _linkStyle = TextStyle(
  decoration: TextDecoration.underline,
  color: Colors.blue,
  fontSize: 20,
);

class Link extends ConsumerWidget {
  final String url;
  final String? text;
  final TextStyle? style;
  final TextStyle? linkStyle;

  const Link(this.url,
      {this.text, this.style, this.linkStyle = _linkStyle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () => _launchURL(url),
        child: Text(
          text == null ? url : text!,
          style: linkStyle,
        ));
  }

  void _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
