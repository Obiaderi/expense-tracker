import 'package:expense_tracker/bar%20graph/my_bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  const ExpenseSummary({
    Key? key,
    required this.startOfWeek,
  }) : super(key: key);

  final DateTime startOfWeek;

  double calculateMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double max = 100;

    List<double> amountList = [
      value.calCulateDailyExpenseSummary()[sunday] ?? 0,
      value.calCulateDailyExpenseSummary()[monday] ?? 0,
      value.calCulateDailyExpenseSummary()[tuesday] ?? 0,
      value.calCulateDailyExpenseSummary()[wednesday] ?? 0,
      value.calCulateDailyExpenseSummary()[thursday] ?? 0,
      value.calCulateDailyExpenseSummary()[friday] ?? 0,
      value.calCulateDailyExpenseSummary()[saturday] ?? 0,
    ];

    for (double amount in amountList) {
      if (amount > max) {
        max = amount;
      }
    }

    return max;
  }

  // calculate the total amount spent for the week
  String calculateWeekTotalAmount(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double totalAmount = 0;

    List<double> amountList = [
      value.calCulateDailyExpenseSummary()[sunday] ?? 0,
      value.calCulateDailyExpenseSummary()[monday] ?? 0,
      value.calCulateDailyExpenseSummary()[tuesday] ?? 0,
      value.calCulateDailyExpenseSummary()[wednesday] ?? 0,
      value.calCulateDailyExpenseSummary()[thursday] ?? 0,
      value.calCulateDailyExpenseSummary()[friday] ?? 0,
      value.calCulateDailyExpenseSummary()[saturday] ?? 0,
    ];

    for (double amount in amountList) {
      totalAmount += amount;
    }

    return totalAmount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd (date) for each day of the week
    // Since we know that the start of the week is Sunday, we can just add days to get the other days
    String sunDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tueDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wedDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thuDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String satDay =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(builder: (context, vm, child) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Row(
              children: [
                const Text('Week Total',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(
                    '\$${calculateWeekTotalAmount(vm, sunDay, monDay, tueDay, wedDay, thuDay, friDay, satDay)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    vm.clearExpenseList();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(
                  vm, sunDay, monDay, tueDay, wedDay, thuDay, friDay, satDay),
              sunAmount: vm.calCulateDailyExpenseSummary()[sunDay] ?? 0,
              monAmount: vm.calCulateDailyExpenseSummary()[monDay] ?? 0,
              tueAmount: vm.calCulateDailyExpenseSummary()[tueDay] ?? 0,
              wedAmount: vm.calCulateDailyExpenseSummary()[wedDay] ?? 0,
              thuAmount: vm.calCulateDailyExpenseSummary()[thuDay] ?? 0,
              friAmount: vm.calCulateDailyExpenseSummary()[friDay] ?? 0,
              satAmount: vm.calCulateDailyExpenseSummary()[satDay] ?? 0,
            ),
          ),
        ],
      );
    });
  }
}
