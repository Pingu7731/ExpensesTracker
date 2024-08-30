import 'package:flutter/material.dart';

class customTiles extends StatelessWidget {
  final String title;
  final String trailing;

  const customTiles({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(trailing),
    );
  }
}
