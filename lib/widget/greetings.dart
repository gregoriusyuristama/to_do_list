import 'package:flutter/material.dart';

const textGreetings = 'Halo';

class Greetings extends StatelessWidget {
  double availableHeight;
  double availableWidth;
  Greetings(this.availableWidth, this.availableHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: availableHeight,
      width: availableWidth,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: FittedBox(
              child: Text(
                textGreetings,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
              child: Text(
                'Jonathan!',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
