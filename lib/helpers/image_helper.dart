import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<File?> getImageFromGallery({
    required BuildContext context,
    required CropStyle cropStyle,
    required String title,
  }) async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final croppedImage = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        cropStyle: cropStyle,
        compressQuality: 70,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: title,
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(),
      );

      return croppedImage!;
    }

    return null;
  }
}
