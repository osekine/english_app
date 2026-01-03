import 'package:flutter/material.dart';

class WordWidget extends StatelessWidget {
  final String text;
  final double width;
  final bool isHighlighted;
  const WordWidget({
    super.key,
    required this.text,
    required this.width,
    this.isHighlighted = false,
  });

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
            blurRadius: 5,
          ),
          if (isHighlighted)
            BoxShadow(
              color: theme.shadowColor,
              offset: Offset(0, 0),
              blurRadius: 6,
              blurStyle: BlurStyle.solid
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
