import 'package:flutter/material.dart';

class WordWidgetShimmer extends StatelessWidget {
  final double width;

  const WordWidgetShimmer({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.primaryColor.withAlpha(100),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(100),
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SizedBox(width: width, height: 32),
    );
  }
}
