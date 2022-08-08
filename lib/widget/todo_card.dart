import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  BoxConstraints constraints;
  String text;
  int priority;
  TodoCard(this.constraints, this.text, this.priority);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 20,
      ),
      child: Container(
        height: constraints.maxHeight * 0.2,
        width: constraints.maxWidth * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black.withAlpha(50),
            )),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  'Priority : ${priority.toString()}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
