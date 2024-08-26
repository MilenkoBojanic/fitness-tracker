import 'package:fitness_tracker/models/category.dart';
import 'package:flutter/material.dart';

class ActivitiesFilter {
  ActivitiesFilter({
    required this.dateRange,
    required this.category,
  });

  final DateTimeRange? dateRange;
  final Category? category;
}
