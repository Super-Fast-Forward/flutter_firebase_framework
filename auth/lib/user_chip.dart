import 'package:auth/user_avatar.dart';
import 'package:auth/user_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChip extends ConsumerWidget {
  final String name;
  final String photoUrl;
  const UserChip(this.name, this.photoUrl);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Chip(label: UserName(name), avatar: UserAvatar(photoUrl));
}
