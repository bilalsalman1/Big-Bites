import 'package:flutter/material.dart';

class ClassName {}

dynamicTitleText({
  required String text,
  double fontSize = 20.0,
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.bold,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
}
