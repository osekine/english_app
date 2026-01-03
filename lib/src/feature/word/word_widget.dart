import 'package:flutter/material.dart';

class WordWidget extends StatelessWidget {
  final String text;
  final double width;
  const WordWidget({super.key, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(100),
            offset: Offset(0, 2),
            blurRadius: 5
          ),
        ],
      ),
      child: SizedBox(
        width: width,
        height: 32,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.primaryTextTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
