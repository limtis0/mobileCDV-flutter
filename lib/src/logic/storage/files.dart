import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getLocalPath() async {
  Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// Gets Uint8List on input and saves it as an image (i.e. test.png)
Future<void> saveImage(Uint8List imageBytes, String fileName) async {
  final String filePath = await getLocalPath();
  final file = File('$filePath/$fileName');
  await file.writeAsBytes(imageBytes);
}

Future<void> removeFile(String fileName) async {
  final String filePath = await getLocalPath();
  final file = File('$filePath/$fileName');
  await file.delete();
}

Future<ImageProvider> imageToWidget(String fileName) async {
  final String filePath = await getLocalPath();
  return Image(image: Image.file(File('$filePath/$fileName')).image).image;
}
