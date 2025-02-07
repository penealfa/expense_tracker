import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
  }

  void openNewExpenseBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("New Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(hintText: "Amount"),
                  )
                ],
              ),
              actions: [
                _createNewExpenseButton(),
                _cancelButton(),
              ],
            ));
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense newExpense = Expense(
              name: nameController.text,
              amount: double.parse(amountController.text),
              date: DateTime.now());

          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: value.allExpenses.length,
            itemBuilder: (context, index) {
              Expense individualExpense = value.allExpenses[index];
              final format = NumberFormat.currency(locale: "en_US", symbol: "ETB", decimalDigits: 2);
              return ListTile(
                title: Text(individualExpense.name),
                trailing: Text(format.format(individualExpense.amount).toString()),
              );
            },
          )),
    );
  }
}
