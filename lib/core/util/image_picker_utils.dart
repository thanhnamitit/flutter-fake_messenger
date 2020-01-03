import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static Future<String> pickImageWithCropper() async {
    String result;
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(
          ratioX: 1.0,
          ratioY: 1.0,
        ),
        maxWidth: 256,
        maxHeight: 256,
      );
      if (croppedFile != null) {
        result = croppedFile.path;
      }
    }
    return result;
  }

  static Future<String> pickImage() async {
    String result;
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      result = pickedFile.path;
    }
    return result;
  }

  static Future<String> takePicture() async {
    String result;
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      result = pickedFile.path;
    }
    return result;
  }
}
