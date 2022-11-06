import 'package:flutter/material.dart';

class SearchTodo extends StatelessWidget {
  final double availableHeight;
  final double availableWidth;

  const SearchTodo(this.availableWidth, this.availableHeight, {Key? key})
      : super(key: key);
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
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
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
