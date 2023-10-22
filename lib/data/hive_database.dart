import 'package:expense_tracker/models/expense_items.dart';
import 'package:expense_tracker/utiils/printty.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  // reference ww opened in the main function
  final _myBox = Hive.box('expense_database');

  // write data to hive
  void saveData(List<ExpenseItems> allExpense) {
    // Hive can only store primitive data types
    // so we need to convert our list of expense items to a list of maps
    // where each map represents an expense item
    List<Map<String, dynamic>> allExpenseMap = [];

    for (var expenseItem in allExpense) {
      allExpenseMap.add(expenseItem.toMap());
    }

    _myBox.put('expense', allExpenseMap);
  }

  // read data from hive
  List<ExpenseItems> readData() {
    printty(_myBox.get('expense'));
    // print(_myBox.get('expense'));
    // read data from hive
    List<dynamic>? allExpenseMap = _myBox.get('expense');

    printty('== $allExpenseMap');

    // convert list of maps to list of expense items
    List<ExpenseItems> allExpense = [];

    if (allExpenseMap == null || allExpenseMap.isEmpty) {
      return allExpense;
    }

    for (var expenseItemMap in allExpenseMap) {
      allExpense.add(ExpenseItems.fromMap(expenseItemMap));
    }

    printty("==== ${allExpense.length}");

    return allExpense;
  }
}
