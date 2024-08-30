import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class customTiles extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? pressedonEdit;
  final void Function(BuildContext)? pressonDelete;

  const customTiles({
    super.key,
    required this.title,
    required this.trailing,
    required this.pressedonEdit,
    required this.pressonDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: pressedonEdit,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: pressonDelete,
            icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}
