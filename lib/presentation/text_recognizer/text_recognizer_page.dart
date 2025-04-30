import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:ocr_demo/presentation/text_recognizer/widgets/action_buttons.dart';
import 'package:pdfx/pdfx.dart';

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
            onSelectPdf: _selectPdf,
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

  //region Image Processing
  Future<void> _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }

  Future<void> _processFile(String path) async {
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
  //endregion

  Future<void> _selectPdf() async {
    setState(() {
      _image = null;
      _path = null;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final document = await PdfDocument.openFile(result.files.single.path!);
    final textFromImages = <String>[];
    for (int i = 0; i < document.pagesCount; i++) {
      final page = await document.getPage(i + 1); // ! must start from 1
      final renderedPage = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.png,
      );
      if (renderedPage == null) continue;

      // ! renderedPage.bytes is PNG-encoded bytes, NOT raw pixel buffer
      // ! thus need to decode PNG bytes to raw pixel data
      final image = img.decodeImage(renderedPage.bytes)!;
      final rawBytes = image.toUint8List();

      // todo: first - i need to check why imageformat invalid
      final inputImage = InputImage.fromBytes(
        bytes: rawBytes,
        metadata: InputImageMetadata(
          size: Size(image.width * 2, image.height * 2),
          rotation: InputImageRotation.rotation0deg,
          // ! image package uses bgra8888 format (4 bytes per pixel (Blue, Green, Red, Alpha))
          format: InputImageFormat.bgra8888,
          // ! since each pixel takes 4 bytes, each row has (image.width) pixel * 4
          bytesPerRow: image.width * 4,
        ),
      );

      // final recognizedText = await _textRecognizer.processImage(inputImage);
      // textFromImages.add(recognizedText.text);
    }

    _text = 'Recognized text:\n\n${textFromImages.join('\n')}';
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _scanPdf() async {}
}
