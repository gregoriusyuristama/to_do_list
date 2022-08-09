import 'package:flutter/material.dart';

const bottomPadding = EdgeInsets.only(left: 25.0, right: 25);

class bottomButton extends StatelessWidget {
  IconData icon;

  bottomButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bottomPadding,
      child: FittedBox(
        child: Icon(
          icon,
          size: 35,
        ),
      ),
    );
  }
}
