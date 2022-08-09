import 'package:flutter/material.dart';

var backgroundCardDecoration = BoxDecoration(
  color: Color.fromRGBO(246, 164, 97, 1.0),
  borderRadius: BorderRadius.circular(50),
);

const counterCardDecoration = BoxDecoration(
  shape: BoxShape.circle,
  // borderRadius: BorderRadius.circular(50),
  color: Color.fromRGBO(244, 183, 132, 1.0),
);
const counterCardMargin = EdgeInsets.all(5);
const counterCardWidth = 40.0;
const counterCardHeight = 50.0;

const counterTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
);
const sizedBoxWidth = 20.0;

const titleTextStyle = TextStyle(fontSize: 18);

class TodoCounter extends StatelessWidget {
  double availableHeight;
  double availableWidth;

  TodoCounter(this.availableWidth, this.availableHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundCardDecoration,
      width: availableWidth,
      height: availableHeight,
      child: Row(
        children: [
          Container(
            margin: counterCardMargin,
            decoration: counterCardDecoration,
            width: counterCardWidth,
            height: counterCardHeight,
            child: counterText('21'),
          ),
          SizedBox(
            width: sizedBoxWidth,
          ),
          textTitle('To Do List'),
        ],
      ),
    );
  }

  Center textTitle(String text) {
    return Center(
      child: FittedBox(
        child: Text(
          text,
          style: titleTextStyle,
        ),
      ),
    );
  }

  Center counterText(String text) {
    return Center(
      child: FittedBox(
        child: Text(
          text,
          style: counterTextStyle,
        ),
      ),
    );
  }
}
