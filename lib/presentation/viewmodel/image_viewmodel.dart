

import 'package:exif_gallery/domain/entity/image_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_viewmodel.g.dart';

class ImageViewState{
  final ImageEntity entity;

  ImageViewState(this.entity);
}

@riverpod
class ImageViewModel extends _$ImageViewModel{
  @override
  ImageViewState build(){
    return ImageViewState(ImageEntity());
  }
}