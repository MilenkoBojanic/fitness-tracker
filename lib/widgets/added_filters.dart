import 'package:fitness_tracker/models/activities_filter.dart';
import 'package:fitness_tracker/utils/formatting_util.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:flutter/material.dart';

class AddedFilters extends StatelessWidget {
  const AddedFilters({
    super.key,
    required this.filters,
    required this.onRemoveFilters,
  });

  final ActivitiesFilter filters;
  final void Function() onRemoveFilters;

  @override
  Widget build(BuildContext context) {
    final isDateRangeAvailable =
        filters.dateRange?.start != null && filters.dateRange?.end != null;
    DateTime startDate = filters.dateRange?.start ?? DateTime.now();
    DateTime endDate = filters.dateRange?.end ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filters:',
                style: primaryColorText,
              ),
              if (filters.category != null)
                Text('Category: ${filters.category?.title}'),
              if (isDateRangeAvailable)
                Text(
                    'Date range: ${readableDate(startDate)} - ${readableDate(endDate)}'),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
              onPressed: () {
                onRemoveFilters();
              },
              label: const Icon(Icons.close)),
        ],
      ),
    );
  }
}
