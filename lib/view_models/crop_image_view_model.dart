import 'dart:io';

import 'package:bluechat/view_models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropImageViewModel extends BaseModel {
  Future cropImage({GlobalKey<CropState> cropKey, File file, File sample}) async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return null;
    }

    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: (2000 / scale).round(),
    );

    final cropedImage = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    sample.delete();

    return cropedImage;
  }
}
