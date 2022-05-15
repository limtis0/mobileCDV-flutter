import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Helper function for functions below
Future<String> getLocalPath() async {
  Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Gets Uint8List on input and saves it as an [name.format] image file
Future<void> saveImage(Uint8List imageBytes, String fileName) async {
  final String filePath = await getLocalPath();
  final file = File('$filePath/$fileName');
  await file.writeAsBytes(imageBytes);
}

/// Removes file from local storage
Future<void> removeFile(String fileName) async {
  final String filePath = await getLocalPath();
  final file = File('$filePath/$fileName');
  await file.delete();
}

/// Provides an image widget for Profile page
Future<ImageProvider> imageToWidget(String fileName) async {
  final String filePath = await getLocalPath();
  return Image(image: Image.file(File('$filePath/$fileName')).image).image;
}
