import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageModel {
  AssetEntity entity;

  ImageModel(this.entity);

  String make = "";
  String focalLength = "";

  Future<void> getExif()  async {
    var file = await entity.file;
    if (file != null) {
      final exifInfo = await readExifFromFile(file);

      final makeEntry = exifInfo.entries.where((e) {
        return e.key.toLowerCase().contains("make");
      });

      make = makeEntry.isNotEmpty ? makeEntry.first.value.toString() : '';

      final focalEntry = exifInfo.entries.where((e) {
        return e.key.toLowerCase().contains("focallength");
      });

      focalLength = focalEntry.isNotEmpty ? focalEntry.first.value.toString() : '';

      // print("${makeEntry.value}, ${focalEntry.value}");
    }
  }

  Future<ImageModel> initModel(AssetEntity entity) async {
    return this;
  }
}
