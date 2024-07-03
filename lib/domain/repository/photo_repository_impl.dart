import 'package:exif/exif.dart';
import 'package:exif_gallery/data/repository/photo_repository.dart';
import 'package:photo_manager/src/types/entity.dart';

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

      var result = exifInfo.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return result;
    }

    return null;
  }
}
