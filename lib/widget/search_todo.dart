import 'package:flutter/material.dart';

class SearchTodo extends StatelessWidget {
  double availableHeight;
  double availableWidth;

  SearchTodo(this.availableWidth, this.availableHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: availableWidth,
      height: availableHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(50),
              color: Colors.transparent,
            ),
            width: 70,
            height: 70,
            child: Center(
              child: FittedBox(
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ),
          ),
          const Center(
            child: FittedBox(
              child: Text(
                'Search To-do-list..',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
