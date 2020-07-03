// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List',
        home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoItem {
  String title;
  bool complete;
  FocusNode todoNode = new FocusNode();
  bool isFocused = false;

  TodoItem(this.title, this.complete);
}

class TodoListState extends State<TodoList> {
  List<TodoItem> _todoItems = [];

  void _editTodoItem(String value, int index) {
    if (value.length > 0) {
      setState(() {
        _todoItems[index].title = value;
        _todoItems[index].isFocused = false;
      });
    }
  }

  void _toggleCompleteTodoItem(int index) {
    setState(() => _todoItems[index].complete = !_todoItems[index].complete);
  }

  void _handlePopup(String value) {
    switch (value) {
      case "Clear Completed":
        setState(() => _todoItems.removeWhere((element) => element.complete));
        break;
      case "Clear All":
        setState(() => _todoItems.clear());
        break;
    }
  }

  void _pushAddTodo() {
    setState(() {
      _todoItems.add(TodoItem("", false));
      _todoItems[_todoItems.length - 1].isFocused = true;
    });
    _todoItems[_todoItems.length - 1].todoNode.requestFocus();
  }

  void _onTapField(index) {
    setState(() {
      _todoItems[index].isFocused = true;
    });
    _todoItems[index].todoNode.requestFocus();
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemCount: _todoItems.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return _buildTodoItem(_todoItems[index].title, index);
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _toggleCompleteTodoItem(index),
          child: _todoItems[index].complete
              ? Icon(Icons.check_box)
              : Icon(
                  Icons.check_box_outline_blank,
                ),
        ),
        title: TextField(
          onTap: () => _onTapField(index),
          onSubmitted: (val) => _editTodoItem(val, index),
          focusNode: _todoItems[index].todoNode,
          decoration: InputDecoration(border: null),
        ),
      ),
    );
  }

  Widget _customAppBar(String text, bool isHome, BuildContext context) {
    return AppBar(
      title: Text("$text"),
      centerTitle: true,
      backgroundColor: Colors.amber,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: _handlePopup,
          itemBuilder: (BuildContext context) {
            return {"Clear Completed", "Clear All"}.map((String choice) {
              return PopupMenuItem(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
    );
  }

  Widget _addButton() {
    if (_todoItems.any((element) => element.isFocused)) {
      return Container();
    } else {
      return FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: _pushAddTodo,
          tooltip: 'Add task',
          child: new Icon(Icons.add));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _customAppBar("Todo List", true, context),
      body: _buildTodoList(),
      floatingActionButton: _addButton(),
    );
  }
}
