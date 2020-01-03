import 'dart:io';

import 'package:flutter/material.dart';

class DynamicImage extends StatelessWidget {
  final String assetPath;
  final String filePath;

  DynamicImage({
    @required this.assetPath,
    @required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return filePath == null
        ? Image.asset(
            assetPath,
            fit: BoxFit.fitHeight,
          )
        : Image.file(
            File(filePath),
            fit: BoxFit.fitHeight,
          );
  }
}
