import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserName extends ConsumerWidget {
  final String name;
  UserName(this.name);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Text(name);
}
