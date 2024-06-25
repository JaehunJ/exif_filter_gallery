import 'package:photo_manager/photo_manager.dart';

class AlbumModel {
  AssetPathEntity albumEntity;

  AlbumModel(this.albumEntity);

  AssetEntity? firstImageEntity;

  String getAlbumName() => albumEntity.name;

  Future<int> getImageCount() async {
    return albumEntity.assetCountAsync;
  }

  Future<List<AssetEntity>> getImageList() async{
    var cnt = await getImageCount();
    return albumEntity.getAssetListRange(start: 0, end: cnt);
  }

  Future<void> getFirstImageEntity() async {
    final entity = await albumEntity.getAssetListRange(start: 0, end: 1);
    firstImageEntity = entity.first;
  }
}
