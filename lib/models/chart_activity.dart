import 'package:intl/intl.dart';

final formatter = DateFormat.Md();

class ChartActivity {
  ChartActivity({
    required this.date,
    required this.duration,
    required this.activitiesNumber,
  });

  final DateTime date;
  int duration;
  int activitiesNumber;

  String get formattedDate {
    return formatter.format(date);
  }
}
