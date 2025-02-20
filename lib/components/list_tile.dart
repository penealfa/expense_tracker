import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final format =
        NumberFormat.currency(locale: "en_US", symbol: "ETB", decimalDigits: 2);
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), 
      children: [
        SlidableAction(onPressed: onEditPressed, icon: Icons.settings,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        borderRadius: BorderRadius.circular(4),
        
        ),
        SlidableAction(onPressed: onDeletePressed, icon: Icons.delete,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        borderRadius: BorderRadius.circular(4),)
      ]),
      child: ListTile(
        title: Text(title),
        trailing: Text(format.format(trailing).toString()),
      ),
    );
  }
}
