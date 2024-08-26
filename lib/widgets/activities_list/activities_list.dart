import 'package:fitness_tracker/models/fitness_activity.dart';
import 'package:fitness_tracker/widgets/activities_list/activity_item.dart';
import 'package:flutter/material.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({
    super.key,
    required this.activities,
    required this.onRemoveActivity,
    required this.onChangeActivity,
  });

  final List<FitnessActivity> activities;
  final void Function(FitnessActivity expense) onRemoveActivity;
  final void Function(FitnessActivity expense) onChangeActivity;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(activities[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) {
          onRemoveActivity(activities[index]);
        },
        child: ActivityItem(
          activity: activities[index],
          onRemoveActivity: onRemoveActivity,
          onChangeActivity: onChangeActivity,
        ),
      ),
    );
  }
}
