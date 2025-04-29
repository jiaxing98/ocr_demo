import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_demo/presentation/text_recognizer/widgets/action_buttons.dart';

class TextRecognizerPage extends StatefulWidget {
  const TextRecognizerPage({super.key});

  @override
  State<TextRecognizerPage> createState() => _TextRecognizerPageState();
}

class _TextRecognizerPageState extends State<TextRecognizerPage> {
  late final TextRecognizer _textRecognizer;
  ImagePicker? _imagePicker;
  File? _image;
  String? _path;
  String? _text;

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _imagePicker = ImagePicker();
  }

  @override
  void dispose() async {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognizer'),
      ),
      body: ListView(
        children: [
          _image != null
              ? SizedBox(
                  height: 400,
                  width: 400,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.file(_image!),
                    ],
                  ),
                )
              : Icon(
                  Icons.image,
                  size: 200,
                ),
          ActionButtons(
            onTakePhoto: () {
              _getImage(ImageSource.camera);
            },
            onSelectPhoto: () {
              _getImage(ImageSource.gallery);
            },
            onScanPdf: () {},
            onSelectPdf: () {},
          ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('${_path == null ? '' : 'Image path: $_path'}\n\n${_text ?? ''}'),
            ),
        ],
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);

    final recognizedText = await _textRecognizer.processImage(inputImage);
    _text = 'Recognized text:\n\n${recognizedText.text}';
    if (mounted) {
      setState(() {});
    }
  }
}
