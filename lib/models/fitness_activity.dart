import 'package:fitness_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class FitnessActivity {
  FitnessActivity({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
    required this.duration,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final Duration duration;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
