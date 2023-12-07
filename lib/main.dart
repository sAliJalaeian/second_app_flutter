import 'package:flutter/material.dart';
import 'package:second/database_helper.dart';
import 'package:second/widgets/todolist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.initialDatabase();

  runApp(MaterialApp(
    title: "SQL TODO APP",
    home: MyApp(databaseHelper: databaseHelper),
  ));
}

class MyApp extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  const MyApp({super.key, required this.databaseHelper});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<TodoListState> _todoListKey = GlobalKey<TodoListState>();

  void refreshTodoList() {
    _todoListKey.currentState?.refreshTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SQL TODO APP",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SQL TODO APP"),
        ),
        body: TodoList(
          key: _todoListKey,
          databaseHelper: widget.databaseHelper,
          refreshCallBack: refreshTodoList
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final TextEditingController controller = TextEditingController();
                return AlertDialog(
                  title: Text("Add TODO"),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Todo',
                    ),
                  ),
                );
              }
            );
          },
        ),
      ),
    );
  }
}