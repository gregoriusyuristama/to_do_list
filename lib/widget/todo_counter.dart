import 'package:flutter/material.dart';

class TodoCounter extends StatelessWidget {
  double availableHeight;
  double availableWidth;

  TodoCounter(this.availableWidth, this.availableHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 164, 97, 1.0),
        borderRadius: BorderRadius.circular(50),
      ),
      width: availableWidth,
      height: availableHeight,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(50),
              color: Color.fromRGBO(244, 183, 132, 1.0),
            ),
            width: 40,
            height: 50,
            child: Center(
              child: FittedBox(
                child: Text(
                  '21',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Center(
            child: FittedBox(
              child: Text(
                "To Do List",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
