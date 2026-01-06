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

class _DraggableWordWidgetState extends State<DraggableWordWidget>
    with TickerProviderStateMixin<DraggableWordWidget> {
  late String text;
  Offset? position;
  bool _isMoving = false;

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
              onDragStarted: () {
                position = _getPosition();
              },
              onDragEnd: (details) {
                _changeDraggable();
                _animateCard(context, details.offset, position!);
              },
              data: text,
              feedback: WordWidget(text: text, width: widget.wordWidth),
              childWhenDragging: WordWidgetShimmer(width: widget.wordWidth),
              child: _isMoving
                  ? WordWidgetShimmer(width: widget.wordWidth)
                  : WordWidget(
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

  void _animateCard(BuildContext context, Offset from, Offset to) {
    _isMoving = true;
    setState(() {});
    final child = WordWidget(text: text, width: widget.wordWidth);

    final overlay = Overlay.of(context);
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final animation = Tween<Offset>(
      begin: from,
      end: to,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    final entry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: animation,
        builder: (_, _) => Positioned(
          left: animation.value.dx,
          top: animation.value.dy,
          child: child,
        ),
      ),
    );
    overlay.insert(entry);

    controller.forward().whenComplete(() {
      _isMoving = false;
      setState(() {});
      entry.remove();
      controller.dispose();
    });
  }

  Offset _getPosition() {
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}
