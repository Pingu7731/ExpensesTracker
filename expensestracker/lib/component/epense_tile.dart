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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: pressedonEdit,
              icon: Icons.edit,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: pressonDelete,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 176, 158, 170),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(title),
            trailing: Text(trailing),
          ),
        ),
      ),
    );
  }
}
