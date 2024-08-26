import 'package:fitness_tracker/models/chart_activity.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.chartActivities,
    required this.desiredDuration,
    required this.desiredNumberOfActivities,
  });

  final List<ChartActivity> chartActivities;
  final int desiredDuration;
  final int desiredNumberOfActivities;

  int get maxDuration {
    int maxDuration = 0;

    for (final chartItem in chartActivities) {
      if (chartItem.duration > maxDuration) {
        maxDuration = chartItem.duration;
      }
    }

    return maxDuration;
  }

  int get maxNumberOfActivities {
    int maxNumberOfActivities = 0;

    for (final chartItem in chartActivities) {
      if (chartItem.activitiesNumber > maxNumberOfActivities) {
        maxNumberOfActivities = chartItem.activitiesNumber;
      }
    }

    return maxNumberOfActivities;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: chartActivities.map((chartItem) {
          return Container(
            width: 50,
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                (desiredDuration > 0)
                    ? ChartBar(
                        fill: chartItem.duration == 0
                            ? 0.2
                            : chartItem.duration / maxDuration,
                        isGoalReached: chartItem.duration >= desiredDuration,
                      )
                    : ChartBar(
                        fill: chartItem.activitiesNumber == 0
                            ? 0.2
                            : chartItem.activitiesNumber /
                                maxNumberOfActivities,
                        isGoalReached: chartItem.activitiesNumber >=
                            desiredNumberOfActivities,
                      ),
                const SizedBox(
                  height: 12,
                ),
                Text(chartItem.formattedDate, style: primaryColorText),
              ],
            ),
          );
        }).toList(),
      ),
    );
    /*
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final chartItem in chartActivities)
                  ChartBar(
                    fill: chartItem.duration == 0
                        ? 0
                        : chartItem.duration / maxDuration,
                    isGoalReached: chartItem.duration >= desiredDuration,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: chartActivities
                .map(
                  (chartItem) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        chartItem.formattedDate,
                        style: primaryColorText,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );*/
  }
}
