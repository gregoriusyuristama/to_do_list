import 'package:flutter/material.dart';

const kDefaultColor = Color.fromRGBO(75, 191, 221, 1.0);

InputDecoration kRegisterFieldDecoration(bool isError) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
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
      color: isError ? Colors.red : kDefaultColor,
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.red,
      ),
    ),
    errorStyle: const TextStyle(
      color: Colors.red,
    ),
  );
}

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

const kTodoBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  color: Color.fromRGBO(247, 251, 255, 1.0),
);

const kModalBotomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(25.0),
  ),
);

const kDefaultBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(75, 191, 221, 1.0),
      Color.fromRGBO(138, 218, 237, 1.0),
    ],
  ),
);

const kTextFieldTextStyle = TextStyle(
  color: kDefaultColor,
  fontWeight: FontWeight.normal,
);

const kDefaultTextColor = TextStyle(
  color: kDefaultColor,
);

const kTitleWidgetCardPadding = EdgeInsets.only(
  // top: 30.0,
  left: 30,
  right: 25,
  // bottom: 15,
);
