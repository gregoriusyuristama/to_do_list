import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';

import '../models/todo.dart';

class AddTodoBottomSheet extends StatefulWidget {
  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  var _myTextController = TextEditingController();
  int prio = 1;
  Color? colour = Colors.grey[700];

  @override
  void dispose() {
    // TODO: implement dispose
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
          'Add New To-Do-List',
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
          decoration: kBottomSheetFieldDecoration.copyWith(
              labelText: 'Your To-Do-List'),
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
          cursorColor: kDefaultColor,
          controller: _myTextController,
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
          builder: (context, todoData, child) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kDefaultColor,
            ),
            onPressed: () {
              todoData.addTodo(_myTextController.text, prio);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ),
      ],
    );
  }
}
