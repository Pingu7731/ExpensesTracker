import 'dart:io';

import 'package:expensestracker/BarGraph/BarGraph.dart';
import 'package:expensestracker/component/epense_tile.dart';
import 'package:expensestracker/database/expense_database.dart';
import 'package:expensestracker/helper/function.dart';
import 'package:expensestracker/model/expense.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();

  Future<Map<int, double>>? monthTotalFuture;
  Future<double>? calculateCurrMontTotal;

  @override
  void initState() {
    Provider.of<ExpenseDb>(context, listen: false).readExpenses();
    refreshData();
    super.initState();
  }

  void refreshData() {
    monthTotalFuture =
        Provider.of<ExpenseDb>(context, listen: false).calculatemonthtotal();
    calculateCurrMontTotal =
        Provider.of<ExpenseDb>(context, listen: false).calculateCurrMontTotal();
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
    return Consumer<ExpenseDb>(builder: (context, value, child) {
      int startmonth = value.getstartmonth();
      int startyear = value.getstartyear();
      int currentmonth = DateTime.now().month;
      int currentyear = DateTime.now().year;
      //get moth count
      int monthcount =
          caulcMonthCount(startyear, startmonth, currentyear, currentmonth);

      //only show currentmonth expenses
      List<Expense> currentmonthexpense = value.allExpense.where((expense) {
        return expense.date.year == currentyear &&
            expense.date.month == currentmonth;
      }).toList();

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: FutureBuilder<double>(
              //get the amount of total stuff
              future: calculateCurrMontTotal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$' + snapshot.data!.toStringAsFixed(2)),
                      Text(getcurrentMonthname()),
                    ],
                  );
                } else {
                  return const Text('Brb Getting Data ( •̀ ω •́ )y');
                }
              }),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // the graph ui
              SizedBox(
                height: 300,
                child: FutureBuilder(
                  future: monthTotalFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final monthlytotal = snapshot.data ?? {};

                      //generate list

                      List<double> monthlysummary = List.generate(monthcount,
                          (index) => monthlytotal[startmonth + index] ?? 0.0);
                      return Bargraph(
                          monthSum: monthlysummary, startmonth: startmonth);
                    } else {
                      return const Center(
                        child: Text("waittt im getting your data"),
                      );
                    }
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: value.allExpense.length,
                  itemBuilder: (context, index) {
                    //reverse expenses list
                    int reverseindex = currentmonthexpense.length - 1 - index;
                    //get the expenses from month
                    Expense individualedpenses =
                        currentmonthexpense[reverseindex];
                    //return the value to the tile
                    return customTiles(
                      title: individualedpenses.name,
                      trailing: changenumberwithicon(individualedpenses.amount),
                      pressedonEdit: (context) =>
                          editExpense(individualedpenses),
                      pressonDelete: (context) =>
                          deleteExpense(individualedpenses),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
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
          refreshData();
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

          refreshData();
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
        refreshData();
      },
      child: const Text('Delete'),
    );
  }
}
