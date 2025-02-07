import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/components/list_tile.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<Map<int, double>>? _monthlyTotalsFuture;
  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    refreshGraphData();
    super.initState();
  }

  void refreshGraphData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
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

  void openEditBox(Expense expense) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: expense.name),
                  ),
                  TextField(
                    controller: amountController,
                    decoration:
                        InputDecoration(hintText: expense.amount.toString()),
                  )
                ],
              ),
              actions: [
                _editExpenseButton(expense),
                _cancelButton(),
              ],
            ));
  }

  void openDeleteBox(Expense expense) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Delete Expense ?"),
              actions: [
                _deleteExpenseButton(expense),
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

          refreshGraphData();
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense updateExpenses = Expense(
              name: nameController.text.isNotEmpty
                  ? nameController.text
                  : expense.name,
              amount: amountController.text.isNotEmpty
                  ? double.parse(amountController.text)
                  : expense.amount,
              date: DateTime.now());
          int existingId = expense.id;
          await context
              .read<ExpenseDatabase>()
              .updateExpenses(existingId, updateExpenses);

          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  Widget _deleteExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);
        int existingId = expense.id;
        await context.read<ExpenseDatabase>().deleteExpenses(existingId);
      },
      child: const Text('Delete'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;
      int monthCount =
          calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                      future: _monthlyTotalsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final monthlyTotals = snapshot.data ?? {};
                          List<double> monthlySummary = List.generate(monthCount,
                              (index) => monthlyTotals[startMonth + index] ?? 0.0);
                  
                          return MyBarGraph(
                              monthlySummary: monthlySummary,
                              startMonth: startMonth);
                        } else {
                          return const Center(
                            child: Text("Loading.."),
                          );
                        }
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: value.allExpenses.length,
                    itemBuilder: (context, index) {
                      Expense individualExpense = value.allExpenses[index];
                      return MyListTile(
                        title: individualExpense.name,
                        trailing: individualExpense.amount.toString(),
                        onEditPressed: (context) => openEditBox,
                        onDeletePressed: (context) => openDeleteBox,
                      );
                    },
                  ),
                )
              ],
            ),
          ));
    });
  }
}
