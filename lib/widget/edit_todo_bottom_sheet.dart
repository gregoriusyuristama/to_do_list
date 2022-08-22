import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/todo_operation.dart';

import '../models/todo.dart';

class EditTodoBottomSheet extends StatefulWidget {
  EditTodoBottomSheet({
    required this.todo,
  });

  ToDo todo;

  @override
  State<EditTodoBottomSheet> createState() => _EditTodoBottomSheet();
}

class _EditTodoBottomSheet extends State<EditTodoBottomSheet> {
  int prio = 1;
  Color? colour = Colors.grey[700];
  Color? labelTextColour = Colors.grey[700];

  var _myTextController = TextEditingController();
  @override
  void initState() {
    _myTextController = TextEditingController(text: widget.todo.todoName);
    prio = widget.todo.priority;
    super.initState();
  }

  @override
  void dispose() {
    _myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Edit To-Do-List',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(75, 191, 221, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        // Divider(
        //   thickness: 2.0,
        //   color: Colors.black,
        // ),
        TextField(
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(75, 191, 221, 1.0)),
            ),
            hintStyle:
                TextStyle(backgroundColor: Color.fromRGBO(75, 191, 221, 1.0)),
            fillColor: Color.fromRGBO(75, 191, 221, 1.0),
            labelText: 'Your To-do-list : ',
            // labelStyle: TextStyle(color: Color.fromRGBO(75, 191, 221, 1.0)),
            floatingLabelStyle: TextStyle(color: labelTextColour),
          ),
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),

          cursorColor: Color.fromRGBO(75, 191, 221, 1.0),
          controller: _myTextController,
          onSubmitted: (value) {
            setState(() {
              labelTextColour = Colors.grey[700];
            });
          },
          onTap: () {
            setState(() {
              labelTextColour = Color.fromRGBO(75, 191, 221, 1.0);
            });
          },

          // scrollPadding: EdgeInsets.only(bottom: 25),
          // autofocus: true,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Priority : ',
          style: TextStyle(
            color: colour,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.left,
        ),
        Slider(
          activeColor: Color.fromRGBO(75, 191, 221, 1.0),
          value: prio.toDouble(),
          label: prio.toInt().toString(),
          min: 1.0,
          max: 5.0,
          divisions: 4,
          onChangeEnd: (value) {
            setState(() {
              colour = Colors.grey[700];
            });
          },
          onChanged: (double newValue) {
            setState(
              () {
                colour = Color.fromRGBO(75, 191, 221, 1.0);
                prio = newValue.toInt();
              },
            );
          },
        ),
        SizedBox(
          height: 30,
        ),
        Consumer<TodoOperation>(
          builder: (context, todoData, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    todoData.deleteTodo(widget.todo);

                    Navigator.pop(context);
                  },
                  child: Text('Remove'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    widget.todo.todoName = _myTextController.text;
                    widget.todo.priority = prio;
                    todoData.updateTodo(widget.todo);

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Color.fromRGBO(75, 191, 221, 1.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
