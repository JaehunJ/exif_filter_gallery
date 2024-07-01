import 'dart:io';

import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart';

import '../util/Constant.dart';

class ImageModel {
  AssetEntity _entity;

  ImageModel(this._entity);

  String make = "";
  String model = "";
  String focalLength = "";
  String exposureTime = "";
  String fNumber = "";
  String iso = "";

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

      final modelEntry = exifInfo.entries.where((e){
        return e.key.toLowerCase().contains("image model");
      });

      model = modelEntry.isNotEmpty ? modelEntry.first.value.toString() : 'none';

      final exif = exifInfo.entries.where((e){
        return e.key.toLowerCase().contains("exif");
      });

      final iso = exif.where((e){
        return e.key.toLowerCase().contains("isospeedratings");
      });

      this.iso = iso.isNotEmpty ? iso.first.value.toString() : '';

      final exposureTime = exif.where((e){
        return e.key.toLowerCase().contains("exposuretime");
      });

      this.exposureTime = exposureTime.isNotEmpty ? exposureTime.first.value.toString() : '';

      final fNumber = exif.where((e){
        return e.key.toLowerCase().contains("fnumber");
      });

      if(fNumber.isNotEmpty){
        final divItem = fNumber.where((e){
          return e.value.toString().contains("/");
        });

        if(divItem.isEmpty){
          this.fNumber = fNumber.first.toString();
        }else{
          final split = divItem.first.value.toString().split("/");

          if(split.isNotEmpty){
            final a = double.parse(split[0]);
            final b = double.parse(split[1]);

            this.fNumber = (a/b).toStringAsFixed(2);
          }else{
            this.fNumber = split.first;
          }
        }
      }else{
        this.fNumber = '';
      }

      final focalEntry = exif.where((e) {
        return e.key.toLowerCase().contains("focallength");
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

      return true;
    }

    return false;
  }

  void getExifToPrint() async{
    var file = await _entity.originBytes;
    if(file != null){
      final exifInfo = await readExifFromBytes(file);

      final exif = exifInfo.entries.where((e){
        return e.key.toLowerCase().contains("exif");
      });

      for(var item in exifInfo.entries){
        print('${item.key}:${item.value}');
      }
    }
  }

  Future<File?> getFile() => _entity.file;

  AssetEntity getAsset() => _entity;

  DateTime getDateTime()=> _entity.createDateTime;

  String getFilterString(Filter filter){
    if(filter == Filter.FOCAL_LENGTH){
      if(focalLength.isNotEmpty && focalLength != FOCAL_LENGTH_MAX){
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
