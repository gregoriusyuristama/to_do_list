import 'package:flutter/material.dart';

import 'todo_card.dart';

class TodoBox extends StatelessWidget {
  double availableHeight;
  double availableWidth;

  TodoBox(this.availableWidth, this.availableHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: Color.fromRGBO(247, 251, 255, 1.0),
      ),
      height: availableHeight,
      width: availableWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.15,
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 30,
                  right: 25,
                  bottom: 15,
                ),
                width: constraints.maxWidth,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your To-do-lists',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Divider(
                height: constraints.maxHeight * 0.05,
                indent: constraints.maxWidth * 0.05,
                endIndent: constraints.maxWidth * 0.05,
                color: Color.fromRGBO(246, 164, 97, 1.0),
              ),
              Container(
                height: constraints.maxHeight * 0.65,
                width: constraints.maxWidth,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TodoCard(constraints, "Homework", 5),
                      TodoCard(constraints, "Programming", 4),
                      TodoCard(constraints, "Do Final Project", 3),
                      TodoCard(constraints, "Read Books", 2),
                      TodoCard(constraints, "Medicine", 1),
                      TodoCard(constraints, "Sleed", 1),
                    ],
                  ),
                ),
              ),
              Divider(
                height: constraints.maxHeight * 0.05,
                color: Color.fromRGBO(246, 164, 97, 1.0),
                indent: constraints.maxWidth * 0.05,
                endIndent: constraints.maxWidth * 0.05,
              ),
              Container(
                height: constraints.maxHeight * 0.1,
                width: constraints.maxWidth,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: Icon(
                        Icons.home_filled,
                        size: 35,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: Icon(
                        Icons.table_chart_rounded,
                        size: 35,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: Icon(
                        Icons.add_box_rounded,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
