
import 'package:photo_manager/photo_manager.dart';


import 'album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository{
  @override
  Future<List<AssetPathEntity>> getAlbumList() async {
    return await PhotoManager.getAssetPathList(type: RequestType.image);
  }
}