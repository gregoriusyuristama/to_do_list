import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
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
  int _prio = 1;
  Color? _colour = Colors.grey[700];
  Color? _labelTextColour = Colors.grey[700];
  bool _validate = false;

  var _myTextController = TextEditingController();
  @override
  void initState() {
    _myTextController = TextEditingController(text: widget.todo.todoName);
    _prio = widget.todo.priority;
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
            color: kDefaultColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        Divider(
          thickness: 2.0,
          color: kDefaultColor,
        ),
        TextField(
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kDefaultColor),
            ),
            hintStyle: TextStyle(backgroundColor: kDefaultColor),
            fillColor: kDefaultColor,
            labelText: 'Your To-do-list : ',
            errorText: _validate ? 'Value Can\'t be Empty' : null,
            floatingLabelStyle: TextStyle(color: _labelTextColour),
          ),
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
          cursorColor: kDefaultColor,
          controller: _myTextController,
          onSubmitted: (value) {
            setState(() {
              _labelTextColour = Colors.grey[700];
            });
          },
          onTap: () {
            setState(() {
              _labelTextColour = kDefaultColor;
            });
          },
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Priority : ',
          style: TextStyle(
            color: _colour,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.left,
        ),
        Slider(
          activeColor: kDefaultColor,
          value: _prio.toDouble(),
          label: _prio.toInt().toString(),
          min: 1.0,
          max: 5.0,
          divisions: 4,
          onChangeEnd: (value) {
            setState(() {
              _colour = Colors.grey[700];
            });
          },
          onChanged: (double newValue) {
            setState(
              () {
                _colour = kDefaultColor;
                _prio = newValue.toInt();
              },
            );
          },
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () async {
                  await Provider.of<TodoOperation>(
                    context,
                    listen: false,
                  ).deleteTodo(widget.todo);
                  Navigator.pop(context);
                },
                child: Text('Remove'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    _myTextController.text.isEmpty
                        ? _validate = true
                        : _validate = false;
                  });
                  if (!_validate) {
                    widget.todo.todoName = _myTextController.text;
                    widget.todo.priority = _prio;
                    await Provider.of<TodoOperation>(
                      context,
                      listen: false,
                    ).updateTodo(widget.todo);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Edit',
                  style: TextStyle(color: kDefaultColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
