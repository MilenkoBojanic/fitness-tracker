import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

String readableDate(DateTime date) {
  return formatter.format(date);
}

String readableTimeOfDay(TimeOfDay time) {
  final String zero = (time.minute < 10) ? '0' : '';
  return '${time.hour}:$zero${time.minute}';
}

String readableDuration(Duration duration) {
  final String hours = (duration.inHours > 0) ? '${duration.inHours} h ' : '';
  return '$hours${duration.inMinutes % 60} min';
}

DateTime? createDateFromString(String date) {
  return formatter.tryParse(date);
}

TimeOfDay? createTimeFromString(String time) {
  try {
    final timeSplit = time.split(':');
    int hours = int.parse(timeSplit[0]);
    int minutes = int.parse(timeSplit[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  } catch (ex) {
    return null;
  }
}

Duration createDurationFromMinutes(int durationMinutes) {
  return Duration(minutes: durationMinutes);
}
