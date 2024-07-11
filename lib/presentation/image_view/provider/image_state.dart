

import 'dart:io';

import 'package:exif_gallery/model/image_grid_model.dart';

class ImageState{
  ImageGridModel entity;
  File? file;

  ImageState({
    required this.entity,
    required this.file,
  });

  ImageState copyWith({
    ImageGridModel? entity,
    File? file,
  }) {
    return ImageState(
      entity: entity ?? this.entity,
      file: file ?? this.file,
    );
  }
}