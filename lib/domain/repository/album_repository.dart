import 'package:photo_manager/photo_manager.dart';


abstract interface class AlbumRepository{
  Future<List<AssetPathEntity>> getAlbumList();
  Future<PermissionState> checkPermission();
}