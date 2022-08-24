import 'package:flutter/material.dart';

const kDefaultColor = Color.fromRGBO(75, 191, 221, 1.0);

var kRegisterFieldDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: kDefaultColor,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Colors.grey[400]!,
    ),
  ),
  labelStyle: TextStyle(
    color: Colors.grey[400],
  ),
  floatingLabelStyle: TextStyle(
    color: kDefaultColor,
  ),
);

const kRegisterTextStyleDecoration = TextStyle(
  color: kDefaultColor,
  fontWeight: FontWeight.normal,
);

const kBottomSheetFieldDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(75, 191, 221, 1.0)),
  ),
  focusColor: Color.fromRGBO(75, 191, 221, 1.0),
  floatingLabelStyle: TextStyle(color: Color.fromRGBO(75, 191, 221, 1.0)),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(75, 191, 221, 1.0)),
  ),
);
