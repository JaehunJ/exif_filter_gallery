
import 'package:photo_manager/photo_manager.dart';


import '../../data/repository/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository{
  @override
  Future<List<AssetPathEntity>> getAlbumList() async {
    return await PhotoManager.getAssetPathList(type: RequestType.image);
  }

  @override
  Future<PermissionState> checkPermission() async{
    return await PhotoManager.requestPermissionExtend();
  }
}