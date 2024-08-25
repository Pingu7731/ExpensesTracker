import 'package:expensestracker/database/expense_database.dart';
import 'package:expensestracker/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;

  await ExpenseDb.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseDb(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
