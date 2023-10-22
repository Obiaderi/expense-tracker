import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    Key? key,
    required this.name,
    required this.dateTime,
    required this.amount,
    this.onPressed,
  }) : super(key: key);

  final String name;
  final DateTime dateTime;
  final double amount;
  final void Function(BuildContext)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        // Delete button
        SlidableAction(
          onPressed: onPressed,
          icon: Icons.delete,
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
      ]),
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          '${dateTime.day}/${dateTime.month}/${dateTime.year}',
        ),
        trailing: Text(
          '\$${amount.toString()}',
        ),
      ),
    );
  }
}
