import 'package:fitness_tracker/utils/formatting_util.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/fitness_activity.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
    required this.onRemoveActivity,
    required this.onChangeActivity,
  });

  final FitnessActivity activity;
  final void Function(FitnessActivity activity) onRemoveActivity;
  final void Function(FitnessActivity activity) onChangeActivity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.category.title,
                            style: categoryTextStyle(activity.category.color),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Text(
                              activity.title,
                              maxLines: null,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        activity.description,
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          onRemoveActivity(activity);
                        },
                        label: const Icon(Icons.delete)),
                    ElevatedButton.icon(
                        onPressed: () {
                          onChangeActivity(activity);
                        },
                        label: const Icon(Icons.edit)),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(
                      readableDate(activity.date),
                      style: primaryColorText,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Time'),
                    Text(
                      readableTimeOfDay(activity.time),
                      style: primaryColorText,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Duration'),
                    Text(
                      readableDuration(activity.duration),
                      style: primaryColorText,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
