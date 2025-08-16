import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends ChangeNotifier {
  File? _image;
  String _result = '';

  File? get image => _image;
  String get result => _result;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
      await _analyzeImage(_image!);
    }
  }

  Future<void> _analyzeImage(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      _result = recognizedText.text;
    } catch (e) {
      print('Error processing image: $e');
      _result = 'Error occurred while processing the image.';
    } finally {
      await textRecognizer.close();
      notifyListeners();
    }
  }
}
