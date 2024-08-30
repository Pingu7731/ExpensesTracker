import 'package:expensestracker/component/epense_tile.dart';
import 'package:expensestracker/database/expense_database.dart';
import 'package:expensestracker/helper/function.dart';
import 'package:expensestracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();

  void init() {
    Provider.of<ExpenseDb>(context, listen: false).readExpenses();
  }

  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Da Fuq You Buy Again?',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namecontroller,
              decoration: const InputDecoration(hintText: "Whachu buy"),
            ),
            TextField(
              controller: amountcontroller,
              decoration: const InputDecoration(hintText: "\$ ?"),
            ),
          ],
        ),
        actions: [
          cancelBUtton(),
          addButton(),
        ],
      ),
    );
  }

  //open dialog when pressed edit button
  void editExpense(Expense expense) {
    String currentname = expense.name;
    String currentamount = expense.amount.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Something Wrong ?',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(hintText: currentname),
            ),
            TextField(
              controller: amountcontroller,
              decoration: InputDecoration(hintText: currentamount),
            ),
          ],
        ),
        actions: [
          cancelBUtton(),
          editButton(expense),
        ],
      ),
    );
  }

  //delete box
  void deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete ?',
          textAlign: TextAlign.center,
        ),
        actions: [
          cancelBUtton(),
          deleteButton(expense.id),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDb>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const Icon(
            Icons.add,
          ),
        ),
        body: ListView.builder(
          itemCount: value.allExpense.length,
          itemBuilder: (context, index) {
            //get the expenses
            Expense individualedpenses = value.allExpense[index];
            //return the value to the tile
            return customTiles(
              title: individualedpenses.name,
              trailing: changenumberwithicon(individualedpenses.amount),
              pressedonEdit: (context) => editExpense(individualedpenses),
              pressonDelete: (context) => deleteExpense(individualedpenses),
            );
          },
        ),
      ),
    );
  }

  Widget cancelBUtton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
  }

  Widget addButton() {
    return MaterialButton(
      onPressed: () async {
        if (namecontroller.text.isNotEmpty &&
            amountcontroller.text.isNotEmpty) {
          Navigator.pop(context);
          Expense newExpense = Expense(
            name: namecontroller.text,
            amount: convertDouble(amountcontroller.text),
            date: DateTime.now(),
          );
          await context.read<ExpenseDb>().createExpenses(newExpense);
          namecontroller.clear();
          amountcontroller.clear();
        }
      },
      child: const Text('Add'),
    );
  }

  Widget editButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (namecontroller.text.isNotEmpty ||
            amountcontroller.text.isNotEmpty) {
          Navigator.pop(context);

          Expense updateExpenses = Expense(
            name: namecontroller.text.isNotEmpty
                ? namecontroller.text
                : expense.name,
            amount: amountcontroller.text.isNotEmpty
                ? convertDouble(amountcontroller.text)
                : expense.amount,
            date: DateTime.now(),
          );

          int currentId = expense.id;

          await context
              .read<ExpenseDb>()
              .updateExpenses(currentId, updateExpenses);
        }
      },
      child: const Text('Save'),
    );
  }

  Widget deleteButton(int id) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);

        await context.read<ExpenseDb>().deleteExpenses(id);
        namecontroller.clear();
        amountcontroller.clear();
      },
      child: const Text('Delete'),
    );
  }
}
