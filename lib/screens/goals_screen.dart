import 'package:duration_picker/duration_picker.dart';
import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/models/chart_activity.dart';
import 'package:fitness_tracker/models/fitness_activity.dart';
import 'package:fitness_tracker/utils/formatting_util.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:fitness_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key, required this.activities});

  final List<FitnessActivity> activities;

  @override
  State<GoalsScreen> createState() {
    return _GoalsScreenState();
  }
}

class _GoalsScreenState extends State<GoalsScreen> {
  // This value should come from API, but it will be initially true for the purpose of this task
  var _switchValue = true;
  var _selectedRange = DateTimeRange(
    start: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
    end: DateTime.now(),
  );
  var _selectedActivitiesNumber = 0;
  var _selectedActivitiesDuration = const Duration(minutes: 30);
  final _controller = TextEditingController();
  final TextInputFormatter _numberFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[1-9]'));
  List<ChartActivity> _chartActivities = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onNumberEntered);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _presentDateRangePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year, now.month + 1, now.day);
    final pickedRange = await showDateRangePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDateRange: _selectedRange);

    setState(() {
      if (pickedRange == null) {
        return;
      }
      _selectedRange = pickedRange;
    });
  }

  void _presentActivitiesDurationPicker() async {
    final pickedDuration = await showDurationPicker(
      context: context,
      initialTime: _selectedActivitiesDuration,
      baseUnit: BaseUnit.minute,
    );
    setState(() {
      if (pickedDuration == null || pickedDuration.inMinutes <= 0) {
        return;
      }
      _selectedActivitiesDuration = pickedDuration;
      _selectedActivitiesNumber = 0;
      _controller.text = '';
    });
  }

  void _onNumberEntered() {
    final enteredNumber = int.tryParse(_controller.text);
    if (enteredNumber == null || enteredNumber < 1 || enteredNumber > 9) {
      setState(() {
        _selectedActivitiesNumber = 0;
      });
    } else {
      setState(() {
        _selectedActivitiesNumber = enteredNumber;
        _selectedActivitiesDuration = const Duration(minutes: 0);
      });
    }
  }

  List<FitnessActivity> getActivitiesInRange(List<FitnessActivity> activities) {
    DateTime startDate = _selectedRange.start;
    DateTime endDate = _selectedRange.end;
    activities.sort((a, b) => a.date.compareTo(b.date));

    final filteredActivities = activities
        .where((activity) =>
            activity.date.isAtSameMomentAs(startDate) ||
            (activity.date.isAfter(startDate) &&
                activity.date.isBefore(endDate)) ||
            activity.date.isAtSameMomentAs(endDate))
        .toList();
    return filteredActivities;
  }

  List<DateTime> getDateTimeList(DateTimeRange range) {
    List<DateTime> dateList = [];
    DateTime currentDate = range.start;

    while (currentDate.isBefore(range.end) ||
        currentDate.isAtSameMomentAs(range.end)) {
      dateList.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return dateList;
  }

  void _calculateActivitiesForChart(List<FitnessActivity> activities) {
    List<FitnessActivity> activitiesInRange = getActivitiesInRange(activities);
    List<ChartActivity> chartActivities = [];

    List<DateTime> dates = getDateTimeList(_selectedRange);
    for (var date in dates) {
      if (activitiesInRange.isEmpty) {
        chartActivities
            .add(ChartActivity(date: date, duration: 0, activitiesNumber: 0));
      } else {
        if (date.isBefore(activitiesInRange.first.date)) {
          chartActivities
              .add(ChartActivity(date: date, duration: 0, activitiesNumber: 0));
        } else {
          var chartActivity =
              ChartActivity(date: date, duration: 0, activitiesNumber: 0);
          List<FitnessActivity> filteredList = activitiesInRange
              .where((activity) => date.isAtSameMomentAs(activity.date))
              .toList();
          for (final item in filteredList) {
            chartActivity.activitiesNumber++;
            chartActivity.duration += item.duration.inMinutes;
            activitiesInRange.removeAt(0);
          }
          chartActivities.add(chartActivity);
        }
      }
    }

    setState(() {
      _chartActivities = chartActivities;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Expanded(
      child: Center(
        child: Text(''),
      ),
    );

    if (_switchValue == false) {
      mainContent = Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const Center(
              child: Text(
            'Goals are turned off. Turn them on to see the chart!',
            maxLines: null,
            textAlign: TextAlign.center,
          )),
        ),
      );
    } else {
      if (_selectedActivitiesNumber == 0 &&
          _selectedActivitiesDuration.inMinutes == 0) {
        mainContent = Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'No goals are set. Set number or duration of activities!',
                maxLines: null,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        _calculateActivitiesForChart(widget.activities);
        mainContent = Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor, width: 1.5),
          ),
          child: Chart(
            chartActivities: _chartActivities,
            desiredDuration: _selectedActivitiesDuration.inMinutes,
            desiredNumberOfActivities: _selectedActivitiesNumber,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'FITNESS',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'GOALS',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Turn goals on or off'),
                  const Spacer(),
                  Switch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                    activeColor: primaryColor,
                    inactiveThumbColor: Colors.grey,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Select desired number of activities or select desired duration of activities in a day:',
                textAlign: TextAlign.center,
                maxLines: null,
              ),
              TextField(
                controller: _controller,
                maxLength: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [_numberFormatter],
                cursorColor: primaryColor,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: roundedPrimaryColorTextFieldBorder,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                style: roundedBorderTextButton,
                onPressed: _presentActivitiesDurationPicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      readableDuration(_selectedActivitiesDuration),
                      style: primaryColorText,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.timer,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Select date range',
                maxLines: null,
              ),
              TextButton(
                style: roundedBorderTextButton,
                onPressed: _presentDateRangePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${readableDate(_selectedRange.start)} - ${readableDate(_selectedRange.end)}',
                      style: primaryColorText,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.calendar_month,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        mainContent,
      ]),
    );
  }
}
