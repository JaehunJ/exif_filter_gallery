
import 'package:photo_manager/photo_manager.dart';

abstract interface class PhotoRepository{
  Future<List<AssetEntity>> getPhotoList(AssetPathEntity album);
  Future<AssetEntity> getFirstPhoto(AssetPathEntity album);
  Future<Map<String, String>?> getExif(AssetEntity entity);
}