import 'package:exif/exif.dart';
import 'package:exif_gallery/model/exif_model.dart';
import 'package:photo_manager/photo_manager.dart';

import '../util/Constant.dart';

class ImageGridModel {
  final AssetEntity entity;

  ImageGridModel({required this.entity});

  Map<String, String> exifModel = {};
}
