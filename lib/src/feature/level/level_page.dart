import 'package:english_app/src/feature/word/word_widget.dart';
import 'package:english_app/src/feature/word/word_widget_shimmer.dart';
import 'package:flutter/material.dart';

class LevelPage extends StatefulWidget {
  final int width;
  final int height;
  final List<String> words;
  const LevelPage({
    super.key,
    required this.width,
    required this.height,
    required this.words,
  });

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context).width - 32;
    final wordWidth = screenSize / widget.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < widget.height; ++i)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int j = 0; j < widget.width; ++j)
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DraggableWordWidget(
                        wordWidth: wordWidth,
                        text: widget.words[i * widget.width + j],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DraggableWordWidget extends StatelessWidget {
  const DraggableWordWidget({
    super.key,
    required this.wordWidth,
    required this.text,
  });

  final double wordWidth;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        return data != null && data != text;
      },
      builder:
          (
            BuildContext context,
            List<String?> candidateData,
            List<dynamic> rejectedData,
          ) {
            final hasHover = candidateData.isNotEmpty;
            return Draggable<String>(
              data: text,
              feedback: WordWidget(text: text, width: wordWidth),
              childWhenDragging: WordWidgetShimmer(width: wordWidth),
              child: WordWidget(
                text: text,
                width: wordWidth,
                isHighlighted: hasHover,
              ),
            );
          },
    );
  }
}
