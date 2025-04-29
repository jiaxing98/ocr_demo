import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final void Function() onTakePhoto;
  final void Function() onSelectPhoto;
  final void Function() onScanPdf;
  final void Function() onSelectPdf;

  const ActionButtons({
    super.key,
    required this.onTakePhoto,
    required this.onSelectPhoto,
    required this.onScanPdf,
    required this.onSelectPdf,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 3,
      children: [
        ElevatedButton(
          child: Text('Take a picture'),
          onPressed: onTakePhoto,
        ),
        ElevatedButton(
          child: Text('From Gallery'),
          onPressed: onSelectPhoto,
        ),
        ElevatedButton(
          child: Text('Scan PDF'),
          onPressed: onScanPdf,
        ),
        ElevatedButton(
          child: Text('Select PDF'),
          onPressed: onSelectPdf,
        ),
      ],
    );
  }
}
