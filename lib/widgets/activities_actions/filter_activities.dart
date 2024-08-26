import 'package:fitness_tracker/data/categories.dart';
import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/models/activities_filter.dart';
import 'package:fitness_tracker/models/category.dart';
import 'package:fitness_tracker/utils/formatting_util.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:flutter/material.dart';

class FilterActivities extends StatefulWidget {
  const FilterActivities({super.key, required this.onFilterActivities});

  final void Function(ActivitiesFilter filter) onFilterActivities;

  @override
  State<FilterActivities> createState() {
    return _FilterActivitiesState();
  }
}

class _FilterActivitiesState extends State<FilterActivities> {
  Category? _selectedCategory;
  DateTimeRange? _selectedRange;

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

  void _submitFilters() {
    if (_selectedRange == null && _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid date range or category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onFilterActivities(
      ActivitiesFilter(
        dateRange: _selectedRange,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDateRangeAvailable =
        _selectedRange?.start != null && _selectedRange?.end != null;
    DateTime startDate = _selectedRange?.start ?? DateTime.now();
    DateTime endDate = _selectedRange?.end ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        children: [
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
                  (isDateRangeAvailable)
                      ? '${readableDate(startDate)} - ${readableDate(endDate)}'
                      : '',
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
          const SizedBox(height: 16),
          const Text(
            'Select category',
            maxLines: null,
          ),
          DropdownButtonFormField(
            value: _selectedCategory,
            items: [
              for (final category in availableCategories.entries)
                DropdownMenuItem(
                  value: category.value,
                  child: Text(
                    category.value.title,
                    style: TextStyle(
                      color: category.value.color,
                    ),
                  ),
                ),
            ],
            borderRadius: BorderRadius.circular(16),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: primaryColorText,
                ),
              ),
              ElevatedButton(
                onPressed: _submitFilters,
                child: const Text('Add Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
