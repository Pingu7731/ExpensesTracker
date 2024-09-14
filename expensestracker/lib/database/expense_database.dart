import 'package:expensestracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDb extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allexpense = [];

  //init db

  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  //get all expenses
  List<Expense> get allExpense => _allexpense;

  //create
  Future<void> createExpenses(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    //read the list again
    readExpenses();
  }

  //read
  Future<void> readExpenses() async {
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    _allexpense.clear();
    _allexpense.addAll(fetchedExpenses);

    //update the ui
    notifyListeners();
  }

  // update
  Future<void> updateExpenses(int id, Expense updatedExpense) async {
    updatedExpense.id = id;
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));
    await readExpenses();
    notifyListeners();
  }

  // delete
  Future<void> deleteExpenses(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));
    await readExpenses();
  }

  //helper for getting month total expenses
  Future<Map<int, double>> calculatemonthtotal() async {
    await readExpenses();
    Map<int, double> monthTotal = {};
    for (var expense in allExpense) {
      int month = expense.date.month;

      if (!monthTotal.containsKey(month)) {
        monthTotal[month] = 0;
      }
      monthTotal[month] = monthTotal[month]! + expense.amount;
    }
    return monthTotal;
  }

  int getstartmonth() {
    if (allExpense.isEmpty) {
      return DateTime.now().month;
    }

    allExpense.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return allExpense.first.date.month;
  }

  int getstartyear() {
    if (allExpense.isEmpty) {
      return DateTime.now().year;
    }

    allExpense.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return allExpense.first.date.year;
  }
}
