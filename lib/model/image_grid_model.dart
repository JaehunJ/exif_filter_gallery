import 'package:exif/exif.dart';
import 'package:exif_gallery/model/exif_model.dart';
import 'package:photo_manager/photo_manager.dart';

import '../util/constant.dart';

class ImageGridModel {
  final AssetEntity entity;

  ImageGridModel({required this.entity});

  Map<String, String> exifModel = {};

  DateTime getDateTime()=> entity.createDateTime;

  String getMakeModel(){
    return '${exifModel[Exif_Key.MAKE.value]} ${exifModel[Exif_Key.MODEL.value]}';
  }

  String getFilterString(Filter filter){
    if(filter == Filter.FOCAL_LENGTH){
      if(exifModel[Exif_Key.FOCAL_LENGTH]!= FOCAL_LENGTH_MAX){
        return '${exifModel[Exif_Key.FOCAL_LENGTH]} mm';
      }else{
        return 'none';
      }
    }else if(filter == Filter.MODEL){
      return getMakeModel();
    }

    return getDateTime().toString();
  }

  int compareMake(ImageGridModel b){
    return getMakeModel().compareTo(b.getMakeModel());
  }

  int compareFocalLength(ImageGridModel b){
    final al = double.parse(this.exifModel[Exif_Key.FOCAL_LENGTH] ?? '0');
    final bl = double.parse(b.exifModel[Exif_Key.FOCAL_LENGTH] ?? '0');

    return al.compareTo(bl);
  }
}
