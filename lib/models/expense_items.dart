import 'dart:convert';

class ExpenseItems {
  final String name;
  final double amount;
  final DateTime dateTime;

  ExpenseItems({
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory ExpenseItems.fromMap(Map<dynamic, dynamic> map) {
    return ExpenseItems(
      name: map['name'] as String,
      amount: map['amount'] as double,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseItems.fromJson(String source) =>
      ExpenseItems.fromMap(json.decode(source) as Map<String, dynamic>);
}
