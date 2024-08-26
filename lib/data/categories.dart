import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/category.dart';

const availableCategories = {
  Categories.run: Category(
    title: 'Run',
    color: Colors.purple,
  ),
  Categories.walk: Category(
    title: 'Walk',
    color: Colors.red,
  ),
  Categories.hike: Category(
    title: 'Hike',
    color: Colors.green,
  ),
  Categories.ride: Category(
    title: 'Ride',
    color: Colors.brown,
  ),
  Categories.swim: Category(
    title: 'Swim',
    color: Colors.blue,
  ),
  Categories.workout: Category(
    title: 'Workout',
    color: Colors.indigo,
  ),
  Categories.hiit: Category(
    title: 'HIIT',
    color: Colors.teal,
  ),
  Categories.other: Category(
    title: 'Other',
    color: Colors.orange,
  ),
};
