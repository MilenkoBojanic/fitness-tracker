import 'package:flutter/material.dart';

enum Categories {
  run,
  walk,
  hike,
  ride,
  swim,
  workout,
  hiit,
  other,
}

class Category {
  const Category({
    required this.title,
    this.color = Colors.orange,
  });

  final String title;
  final Color color;
}
