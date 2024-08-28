import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();

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
        actions: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

Widget _cancelbutton() {
  return MaterialButton(
    onPressed: () {},
  );
}
