import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  const UserAvatar(
    this.photoUrl, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return photoUrl == null
        ? Icon(Icons.person)
        : CircleAvatar(
            radius: 50, backgroundImage: Image.network(photoUrl!).image);
  }
}
