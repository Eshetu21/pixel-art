// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class PixelGrid extends StatefulWidget {
  const PixelGrid({super.key});

  @override
  State<PixelGrid> createState() => _PixelGridState();
}

class _PixelGridState extends State<PixelGrid> {
  late int rows;
  late int columns;
  late List<List<Color>> grid;

  Color selectedColor = Colors.black;

  final TransformationController _transformationController =
      TransformationController();
  late double _currentScale;
  final double _minScale = 1.0;
  final double _maxScale = 5.0;

  @override
  void initState() {
    super.initState();

    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    final screenHeight = WidgetsBinding.instance.window.physicalSize.height /
        WidgetsBinding.instance.window.devicePixelRatio;
    const double pixelSize = 14.0;
    rows = (screenHeight ~/ pixelSize) - 4;
    columns = (screenWidth ~/ pixelSize);
    grid = List.generate(rows, (_) => List.filled(columns, Colors.white));

    _currentScale = _minScale;
  }

  void updatePixel(int row, int col, Color color) {
    setState(() {
      grid[row][col] = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double pixelSize = 15.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (Color color in [
                  Colors.white,
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                  Colors.pink,
                ])
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: selectedColor, width: 5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onScaleUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    _currentScale =
                        (_transformationController.value.getMaxScaleOnAxis() *
                                details.scale)
                            .clamp(_minScale, _maxScale);
                    _transformationController.value = Matrix4.identity()
                      ..scale(_currentScale);
                  });
                },
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: _minScale,
                  maxScale: _maxScale,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: rows * columns,
                    itemBuilder: (context, index) {
                      int row = index ~/ columns;
                      int col = index % columns;
                      return GestureDetector(
                        onTap: () {
                          updatePixel(row, col, selectedColor);
                        },
                        child: Container(
                          color: grid[row][col],
                          width: pixelSize,
                          height: pixelSize,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
