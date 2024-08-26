import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.isGoalReached,
  });

  final double fill;
  final bool isGoalReached;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: fill,
          widthFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: isGoalReached ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
