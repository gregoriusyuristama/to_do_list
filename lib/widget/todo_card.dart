import 'package:flutter/material.dart';

const cardPadding = EdgeInsets.only(
  left: 10.0,
  right: 10.0,
  bottom: 20,
);
var cardBoxDecorator = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: Colors.black.withAlpha(50),
  ),
);

const contentPadding = EdgeInsets.only(left: 25.0);

class TodoCard extends StatelessWidget {
  double width;
  double height;
  String text;
  int priority;
  TodoCard(this.width, this.height, this.text, this.priority);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: cardPadding,
      child: Container(
        height: height * 0.15,
        width: width * 0.9,
        decoration: cardBoxDecorator,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: contentPadding,
                child: cardContent(text: text, priority: priority),
              ),
            ),
            Expanded(
              child: Icon(
                Icons.check_circle_outline_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cardContent extends StatelessWidget {
  const cardContent({
    Key? key,
    required this.text,
    required this.priority,
  }) : super(key: key);

  final String text;
  final int priority;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          'Priority : ${priority.toString()}',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
