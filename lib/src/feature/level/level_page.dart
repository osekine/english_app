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
  Object? cardData;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context).width - 32;
    final wordWidth = screenSize / widget.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.0,
            children: [
              for (int i = 0; i < widget.height; ++i)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int j = 0; j < widget.width; ++j)
                      DraggableWordWidget(
                        wordWidth: wordWidth,
                        text: widget.words[i * widget.width + j],
                        onDragStart: _saveDataFromDragTarget,
                        onDragComplete: () => _card,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDataFromDragTarget(Object? obj) {
    cardData = obj;
  }

  Object? get _card => cardData;
}

class DraggableWordWidget extends StatefulWidget {
  const DraggableWordWidget({
    super.key,
    required this.wordWidth,
    required this.text,
    required this.onDragStart,
    required this.onDragComplete,
  });

  final double wordWidth;
  final String text;
  final void Function(Object?) onDragStart;
  final Object? Function() onDragComplete;

  @override
  State<DraggableWordWidget> createState() => _DraggableWordWidgetState();
}

class _DraggableWordWidgetState extends State<DraggableWordWidget> {
  late String text;

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        widget.onDragStart(text);
        return data != null && data != text;
      },
      onAcceptWithDetails: (details) {
        _changeText('${details.data}');
      },
      builder:
          (
            BuildContext context,
            List<String?> candidateData,
            List<dynamic> rejectedData,
          ) {
            final hasHover = candidateData.isNotEmpty;
            return Draggable<String>(
              onDragCompleted: _changeDraggable,
              data: text,
              feedback: WordWidget(text: text, width: widget.wordWidth),
              childWhenDragging: WordWidgetShimmer(width: widget.wordWidth),
              child: WordWidget(
                text: text,
                width: widget.wordWidth,
                isHighlighted: hasHover,
              ),
            );
          },
    );
  }

  void _changeText(String newText) {
    if (newText != text) {
      text = newText;
      setState(() {});
    }
  }

  void _changeDraggable() {
    final a = widget.onDragComplete();
    if (a != null && a != text) {
      text = '$a';
      setState(() {});
    }
  }
}
