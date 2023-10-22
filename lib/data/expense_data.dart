import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_items.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  List<ExpenseItems> overallExpenseList = [];

  List<ExpenseItems> getAllExpenseList() {
    return overallExpenseList;
  }

  // Prepare Data to display
  final db = HiveDatabase();
  void prepareDataToDisplay() {
    if (db.readData().isEmpty) {
      overallExpenseList = [];
    } else {
      overallExpenseList = db.readData();
    }
    notifyListeners();
  }

  void addExpenseItem(ExpenseItems expenseItem) {
    overallExpenseList.add(expenseItem);
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  void removeExpenseItem(ExpenseItems expenseItem) {
    overallExpenseList.remove(expenseItem);
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  void updateExpenseItem(ExpenseItems expenseItem, int index) {
    overallExpenseList[index] = expenseItem;
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  void clearExpenseList() {
    overallExpenseList.clear();
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  int getExpenseListLength() {
    return overallExpenseList.length;
  }

  // get weekday (Mon, Tue, Wed, etc.) from dateTime object
  String getDayName(DateTime dateTime) {
    return dateTime.weekday == 1
        ? 'Mon'
        : dateTime.weekday == 2
            ? 'Tue'
            : dateTime.weekday == 3
                ? 'Wed'
                : dateTime.weekday == 4
                    ? 'Thu'
                    : dateTime.weekday == 5
                        ? 'Fri'
                        : dateTime.weekday == 6
                            ? 'Sat'
                            : 'Sun';
  }

// get start of week date (Sunday) from today's date
// if today is Sunday, return today's date
// if today is not Sunday, return the date of the most recent Sunday
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  Map<String, double> calCulateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.tryParse(expense.amount.toString())!;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
