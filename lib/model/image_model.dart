import 'dart:io';

import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart';

import '../util/Constant.dart';

class ImageModel {
  AssetEntity _entity;

  ImageModel(this._entity);

  String make = "";
  String focalLength = "";

  Future<bool> getExif()  async {
    if(make.isNotEmpty || focalLength.isNotEmpty)
      return true;

    var file = await _entity.file;
    if (file != null) {
      final exifInfo = await readExifFromFile(file);

      final makeEntry = exifInfo.entries.where((e) {
        return e.key.toLowerCase().contains("make");
      });

      make = makeEntry.isNotEmpty ? makeEntry.first.value.toString() : 'none';

      final focalEntry = exifInfo.entries.where((e) {
        return e.key.toLowerCase().contains("focallength");
      });

      focalLength = focalEntry.isNotEmpty ? focalEntry.first.value.toString() : 'none';

      return true;
    }

    return false;
  }

  Future<ImageModel> initModel(AssetEntity entity) async {
    return this;
  }

  Future<File?> getFile() => _entity.file;

  AssetEntity getAsset() => _entity;

  DateTime getDateTime()=> _entity.createDateTime;

  String getFilterString(Filter filter){
    if(filter == Filter.FOCAL_LENGTH){
      return focalLength;
    }else if(filter == Filter.MODEL){
      return make;
    }

    return getDateTime().toString();
  }
}
