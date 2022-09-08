import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';

class AddTodoBottomSheet extends StatefulWidget {
  const AddTodoBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final _myTextController = TextEditingController();
  int _prio = 1;
  Color? _colour = Colors.grey[700];
  bool _validate = false;
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
        const Text(
          'Add New To-Do-List',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kDefaultColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        const Divider(
          thickness: 2.0,
          color: kDefaultColor,
        ),
        TextField(
          decoration: kBottomSheetFieldDecoration.copyWith(
            labelText: 'Your To-Do-List',
            errorText: _validate ? 'Value Can\'t be Empty' : null,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          cursorColor: kDefaultColor,
          controller: _myTextController,
          autofocus: true,
        ),
        const SizedBox(
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
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDefaultColor,
          ),
          onPressed: () {
            setState(() {
              _myTextController.text.isEmpty
                  ? _validate = true
                  : _validate = false;
            });
            if (!_validate) {
              Provider.of<TodoOperation>(context, listen: false)
                  .addTodo(_myTextController.text, _prio);
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
