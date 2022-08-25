import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:to_do_list/screen/welcome_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

const textGreetings = 'Hi,';

class Greetings extends StatelessWidget {
  Greetings(this.name);

  String name;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        alignment: FractionalOffset.bottomCenter,
        child: Row(
          children: [
            Container(
              height: constraints.maxHeight * 0.7,
              width: constraints.maxWidth * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                '$textGreetings $name',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 40),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: constraints.maxHeight * 0.7,
              width: constraints.maxWidth * 0.1,
              alignment: Alignment.centerLeft,
              child: Consumer<TodoOperation>(
                builder: (context, todoData, child) => IconButton(
                  onPressed: () async {
                    await Authentication.signOut(context: context);
                    todoData.clearTodoList();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    FontAwesomeIcons.signOut,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
