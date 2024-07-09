

import 'dart:io';

import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/entity/image_entity.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_viewmodel.g.dart';

class ImageViewState{
  final AssetEntity entity;
  final File? file;

  const ImageViewState({
    required this.entity,
    required this.file,
  }); // ImageViewState(this.entity, this.file);

  ImageViewState copyWith({
    AssetEntity? entity,
    File? file,
  }) {
    return ImageViewState(
      entity: entity ?? this.entity,
      file: file ?? this.file,
    );
  }
}

@riverpod
class ImageViewModel extends _$ImageViewModel{
  final getFileUseCase = injector.get<GetFileUseCase>();
  @override
  FutureOr<ImageViewState> build(AssetEntity entity){
    return ImageViewState(entity: entity, file: null);
  }

  // Future<ImageViewState> fetchImage(){
  //
  // }

  Future<File?> _getFile(AssetEntity p){
    return getFileUseCase.invoke(p);
  }
}