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

    var file = await _entity.originBytes;
    if (file != null) {
      final exifInfo = await readExifFromBytes(file);

      final makeEntry = exifInfo.entries.where((e) {
        return e.key.toLowerCase().contains("make");
      });

      make = makeEntry.isNotEmpty ? makeEntry.first.value.toString() : 'none';

      final focalEntry = exifInfo.entries.where((e) {
        return e.key.contains("FocalLength");
      });

      if(focalEntry.isNotEmpty){
        final divItem = focalEntry.where((e){
          return e.value.toString().contains("/");
        });

        if(divItem.isNotEmpty){
          final split = divItem.first.value.toString().split("/");

          if(split.isNotEmpty && split.length > 1){
            final p = double.parse(split[0]);
            final div = double.parse(split[1]);
            // final finalFocalLength =
            focalLength = (p/div).toStringAsFixed(2);
            // print("result: ${(p/div).toStringAsFixed(1)}");
            // focalLength =
          }
        }else{
          focalLength = focalEntry.first.value.toString();
        }
      }else{
        focalLength = FOCAL_LENGTH_MAX;
      }

      // focalLength = focalEntry.isNotEmpty ? focalEntry.first.value.toString() : 'none';

      return true;
    }

    return false;
  }

  void getExifFromPrint() async{
    var file = await _entity.originBytes;
    if(file != null){
      final exifInfo = await readExifFromBytes(file);
      final entries = exifInfo.entries.where((e){
        return e.key.toLowerCase().contains("exif");
      }).toList();

      for(var item in entries){
        print("${item.key}: ${item.value}");
      }

      final focalEntry = exifInfo.entries.where((e) {
        return e.key.contains("FocalLength");
      });

      if(focalEntry.isNotEmpty){
        final divItem = focalEntry.where((e){
          return e.value.toString().contains("/");
        });

        if(divItem.isNotEmpty){
          final split = divItem.first.value.toString().split("/");

          if(split.isNotEmpty && split.length > 1){
            final p = double.parse(split[0]);
            final div = double.parse(split[1]);
            // final finalFocalLength =
            print("result: ${(p/div).toStringAsFixed(1)}");
            // focalLength =
          }
        }
      }
    }
  }

  Future<ImageModel> initModel(AssetEntity entity) async {
    return this;
  }

  Future<File?> getFile() => _entity.file;

  AssetEntity getAsset() => _entity;

  DateTime getDateTime()=> _entity.createDateTime;

  String getFilterString(Filter filter){
    if(filter == Filter.FOCAL_LENGTH){
      if(focalLength.isNotEmpty || focalLength != FOCAL_LENGTH_MAX){
        return focalLength;
      }else{
        return 'none';
      }
    }else if(filter == Filter.MODEL){
      return make;
    }

    return getDateTime().toString();
  }

  int compareMake(ImageModel b){
    return this.make.compareTo(b.make);
  }

  int compareFocalLength(ImageModel b){
    final al = double.parse(this.focalLength);
    final bl = double.parse(b.focalLength);

    return al.compareTo(bl);
  }
}
