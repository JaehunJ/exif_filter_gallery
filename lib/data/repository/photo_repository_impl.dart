import 'dart:io';

import 'package:exif/exif.dart';
import 'package:photo_manager/src/types/entity.dart';

import '../../domain/repository/photo_repository.dart';
import '../../util/constant.dart';
import '../../util/string_util.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  @override
  Future<List<AssetEntity>> getPhotoList(AssetPathEntity album) async {
    final cnt = await album.assetCountAsync;
    return album.getAssetListRange(start: 0, end: cnt);
  }

  @override
  Future<AssetEntity> getFirstPhoto(AssetPathEntity album) async {
    return (await album.getAssetListPaged(page: 0, size: 1)).first;
  }

  @override
  Future<Map<String, String>?> getExif(AssetEntity entity) async {
    final file = await entity.originBytes;
    if (file != null) {
      final exifInfo = await readExifFromBytes(file);
      final returnMap = <String, String>{};

      for (var e in exifInfo.entries) {
        final lowerKey = e.key.toLowerCase();
        String eKey = '';
        String value = '';
        if(lowerKey.contains(Exif_Key.MAKE.value)){
          eKey = Exif_Key.MAKE.value;
          value = e.value.toString();

          returnMap[eKey] = value;
        }else if(lowerKey.contains(Exif_Key.MODEL.value)){
          eKey = Exif_Key.MODEL.value;
          value = e.value.toString();

          returnMap[eKey] = value;
        }else if(lowerKey.contains(Exif_Key.ISO.value)){
          eKey = Exif_Key.ISO.value;
          value = e.value.toString();

          returnMap[eKey] = value;
        }else if(lowerKey.contains(Exif_Key.FNUMBER.value)){
          eKey = Exif_Key.FNUMBER.value;
          value = e.value.toString();

          if(value.contains('/')){
            value = getExifValueDiv(value);
          }

          returnMap[eKey] = value;
        }else if(lowerKey.contains(Exif_Key.SHUTTER_SPEED.value)){
          eKey = Exif_Key.SHUTTER_SPEED.value;
          value = e.value.toString();

          returnMap[eKey] = value;
        }else if(lowerKey.contains(Exif_Key.FOCAL_LENGTH.value)){
          eKey = Exif_Key.FOCAL_LENGTH.value;
          value = e.value.toString();

          if(value.contains('/')){
            value = getExifValueDiv(value);
          }

          returnMap[eKey] = value;
        }
      }

      return returnMap;
    }

    return null;
  }

  @override
  Future<File?> getFile(AssetEntity entity) async {
    return await entity.file;
  }
}
