import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseData>().prepareDataToDisplay();
    });
  }

  _save() {
    if (newExpenseNameController.text.isEmpty ||
        newExpenseAmountController.text.isEmpty) {
      Navigator.pop(context);
      // show a snackbar
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All the fields are required'),
        ),
      );
    }
    ExpenseItems newExpense = ExpenseItems(
      name: newExpenseNameController.text,
      amount: double.parse(newExpenseAmountController.text),
      dateTime: DateTime.now(),
    );

    context.read<ExpenseData>().addExpenseItem(newExpense);
    _clear();
    Navigator.pop(context);
  }

  _deleteExpenseItem(ExpenseItems expenseItem) {
    context.read<ExpenseData>().removeExpenseItem(expenseItem);
  }

  _cancel() {
    _clear();
    Navigator.pop(context);
  }

  _clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  void _addNewExpense() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: newExpenseAmountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(onPressed: _cancel, child: const Text('cancel')),
          MaterialButton(onPressed: _save, child: const Text('Add Expense')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<ExpenseData>(
        builder: (context, expenseVmodel, child) {
          return ListView(
            children: [
              ExpenseSummary(
                startOfWeek: expenseVmodel.startOfWeekDate(),
              ),
              const SizedBox(height: 20),
              expenseVmodel.getExpenseListLength() == 0
                  ? const Center(
                      child: Text('No Expense'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expenseVmodel.getExpenseListLength(),
                      itemBuilder: (context, index) {
                        return ExpenseTile(
                          name: expenseVmodel.getAllExpenseList()[index].name,
                          dateTime:
                              expenseVmodel.getAllExpenseList()[index].dateTime,
                          amount:
                              expenseVmodel.getAllExpenseList()[index].amount,
                          onPressed: (context) => _deleteExpenseItem(
                            expenseVmodel.getAllExpenseList()[index],
                          ),
                        );
                      },
                    ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => _addNewExpense(),
        tooltip: 'All Expense',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
