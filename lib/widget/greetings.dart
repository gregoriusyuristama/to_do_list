import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/welcome_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

import '../utils/constants.dart';

const textGreetings = 'Hi,';

class Greetings extends StatelessWidget {
  const Greetings(this.name, {Key? key}) : super(key: key);

  final String name;
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
              child: IconButton(
                onPressed: () async {
                  bool _confimation = false;
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                        'Do you want to log out? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                            return;
                          },
                          child: const Text('Cancel', style: kDefaultTextColor),
                        ),
                        TextButton(
                          onPressed: () {
                            _confimation = true;
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('OK', style: kDefaultTextColor),
                        ),
                      ],
                    ),
                  );
                  if (_confimation) {
                    await Authentication.signOut(context: context);
                    Provider.of<TodoOperation>(context, listen: false)
                        .clearTodoList();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
