import 'package:flutter/material.dart';
import 'package:second/database_helper.dart';

import '../model.dart';

class TodoList extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  final VoidCallback refreshCallBack;

  const TodoList({
    super.key,
    required this.databaseHelper,
    required this.refreshCallBack
  });

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  late Future<List<Todo>> todos;
  @override
  void initState() {
    super.initState();
    refreshTodoList();
  }

  Future<void> refreshTodoList() async {
    setState(() {
      todos = widget.databaseHelper.getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
    future: todos,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } if (snapshot.hasError) {
        return Center(child: Text("This is a the error : ${snapshot.error}"));
      } if (snapshot.hasData) {
        final todoList = snapshot.data!;
        return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
          final todo = todoList[index];
          return ListTile(
            title: Text(todo.title),
            trailing: IconButton(
              onPressed: () async {
                await widget.databaseHelper.deleteTodo(todo.id!);
                widget.refreshCallBack();
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
      }
      return const Center(child: Text("There is no todo"));
    });
  }
}
