import 'package:flutter/material.dart';
import 'package:second/database_helper.dart';
import 'package:second/model.dart';
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
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final TextEditingController controller = TextEditingController();
                return AlertDialog(
                  title: const Text("Add TODO"),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Todo',
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () async {
                      final newTodo = Todo(title: controller.text, isCompleted: false);
                      await widget.databaseHelper.insertTodo(newTodo);
                      controller.clear();
                      Navigator.of(context).pop();
                      refreshTodoList();
                    }, child: const Text("Add"))
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }
}