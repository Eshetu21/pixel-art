import 'package:flutter/material.dart';

class Pixelgrid extends StatefulWidget {
  const Pixelgrid({super.key});

  @override
  State<Pixelgrid> createState() => _PixelgridState();
}

class _PixelgridState extends State<Pixelgrid> {
  final int rows = 16;
  final int columns = 16;
  List<List<Color>> grid =
      List.generate(16, (i) => List.filled(16, Colors.white));

  void updatePixel(int row, int col, Color color) {
    setState(() {
      grid[row][col] = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns, crossAxisSpacing: 1, mainAxisSpacing: 1),
        itemCount: rows * columns,
        itemBuilder: (context, index) {
          int row = index ~/ columns;
          int col = index % columns;
          return GestureDetector(
            onTap: () {
              updatePixel(row, col, Colors.black);
            },
            child: Container(
              color: grid[row][col],
              width: 30,
              height: 30,
            ),
          );
        });
  }
}
