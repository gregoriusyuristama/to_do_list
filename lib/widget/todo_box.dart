import 'package:flutter/material.dart';

import 'bottom_button.dart';
import 'todo_card.dart';

const titleBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  ),
  color: Color.fromRGBO(247, 251, 255, 1.0),
);
const titleWidgetCardPadding = EdgeInsets.only(
  top: 30.0,
  left: 30,
  right: 25,
  bottom: 15,
);

class TodoBox extends StatelessWidget {
  double availableHeight;
  double availableWidth;

  TodoBox(this.availableWidth, this.availableHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: titleBoxDecoration,
      height: availableHeight,
      width: availableWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              titleWidgetCard(
                constraints.maxWidth,
                constraints.maxHeight * 0.125,
                context,
              ),
              sectionDivider(
                constraints.maxHeight * 0.025,
              ),
              todoCardContainer(
                constraints.maxWidth,
                constraints.minHeight,
                0.7,
              ),
              sectionDivider(
                constraints.maxHeight * 0.025,
              ),
              bottomNavBar(constraints.maxWidth, constraints.maxHeight * 0.125),
            ],
          );
        },
      ),
    );
  }

  Container titleWidgetCard(double width, double height, BuildContext context) {
    return Container(
      height: height,
      padding: titleWidgetCardPadding,
      alignment: FractionalOffset.bottomLeft,
      width: width,
      child: Text(
        'Your To-do-lists',
        style: Theme.of(context).textTheme.headline3,
        textAlign: TextAlign.left,
      ),
    );
  }
}

Divider sectionDivider(double height) {
  return Divider(
    height: height,
    thickness: 1,
  );
}

Container todoCardContainer(
    double width, double height, double cardHeightFactor) {
  return Container(
    height: height * cardHeightFactor,
    width: width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          TodoCard(width, height, "Homework", 5),
          TodoCard(width, height, "Programming", 4),
          TodoCard(width, height, "Do Final Project", 3),
          TodoCard(width, height, "Read Books", 2),
          TodoCard(width, height, "Medicine", 1),
          TodoCard(width, height, "Sleep", 1),
        ],
      ),
    ),
  );
}

Container bottomNavBar(double width, double height) {
  return Container(
    height: height,
    width: width,
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        bottomButton(Icons.home_filled),
        bottomButton(Icons.table_chart_rounded),
        bottomButton(Icons.add_box_rounded),
      ],
    ),
  );
}
