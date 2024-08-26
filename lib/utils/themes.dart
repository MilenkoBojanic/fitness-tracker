import 'package:fitness_tracker/main.dart';
import 'package:flutter/material.dart';

const primaryColorText = TextStyle(color: primaryColor);

TextStyle categoryTextStyle(Color color) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
}

final roundedBorderTextButton = TextButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
    side: const BorderSide(
      color: primaryColor,
      width: 1.5,
    ),
  ),
);

final roundedPrimaryColorTextFieldBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: primaryColor, width: 1.5),
  borderRadius: BorderRadius.circular(16),
);
