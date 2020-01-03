import 'dart:io';

import 'package:flutter/material.dart';

class DynamicCircleAvatar extends StatelessWidget {
  final String assetPath;
  final String filePath;

  const DynamicCircleAvatar(
      {Key key, @required this.assetPath, @required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: filePath == null
          ? AssetImage(
              assetPath,
            )
          : FileImage(
              File(filePath),
            ),
    );
  }
}
