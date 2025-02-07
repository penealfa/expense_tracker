import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


class ExpenseDatabase extends ChangeNotifier{
    static late Isar isar;
    // ignore: prefer_final_fields
    List<Expense> _allExpenses = [];



    static Future<void> initialize() async {
        final dir = await getApplicationDocumentsDirectory();
        isar = await Isar.open([ExpenseSchema], directory: dir.path);

    }


    //get all
    List<Expense> get allExpenses => _allExpenses;
    // create
    Future<void> createNewExpense(Expense newExpense) async {
        //newExpense.id = BigInt.from(Isar.autoIncrement);
        await isar.writeTxn(()=> isar.expenses.put(newExpense));

        await readExpenses();

    }
    // Read
     Future<void> readExpenses() async {

        List<Expense> featchedExpenses = await isar.expenses.where().findAll();

        _allExpenses.clear();
        _allExpenses.addAll(featchedExpenses);

        notifyListeners();
     }

     // update

     Future<void> updateExpenses(int id, Expense updatedExpense) async {

        updatedExpense.id = id;
        await isar.writeTxn(()=> isar.expenses.put(updatedExpense));

        await readExpenses();
     }

    // Delete

    Future<void> deleteExpenses(int id) async {
        await isar.writeTxn(()=> isar.expenses.delete(id));

        await readExpenses();
    }

}