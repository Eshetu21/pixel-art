import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveGridData(List<List<Color>> grid) async {
  List<List<String>> colorData =
      grid.map((row) => row.map((e) => e.toString()).toList()).toList();
  await _firestore.collection('artworks').doc('artPieceId').set({
    'grid': colorData,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<List<List<Color>>> loadGridData() async {
  DocumentSnapshot doc =
      await _firestore.collection('artworks').doc('artPieceId').get();
  List<List<dynamic>> data = doc['grid'];
  return data
      .map((row) => row.map((e) => Color(int.parse(e))).toList())
      .toList();
}
