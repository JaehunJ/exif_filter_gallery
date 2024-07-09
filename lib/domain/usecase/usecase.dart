import 'dart:io';

import 'package:exif_gallery/data/repository/photo_repository.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../data/repository/album_repository.dart';
import 'base_usecase.dart';

class GetAlbumListUseCase implements BaseUseCase<List<AssetPathEntity>, void> {
  final AlbumRepository repo;

  GetAlbumListUseCase({required this.repo});

  @override
  Future<List<AssetPathEntity>> invoke(void p) async {
    return repo.getAlbumList();
  }
}

class GetImageListUseCase implements BaseUseCase<List<AssetEntity>, AssetPathEntity> {
  final PhotoRepository repo;

  GetImageListUseCase({required this.repo});

  @override
  Future<List<AssetEntity>> invoke(AssetPathEntity p) async {
    final cnt = await p.assetCountAsync;
    return p.getAssetListRange(start: 0, end: cnt);
  }
}

class GetImageFirstUseCase implements BaseUseCase<AssetEntity, AssetPathEntity> {
  final PhotoRepository repo;

  GetImageFirstUseCase({required this.repo});

  @override
  Future<AssetEntity> invoke(AssetPathEntity p) async {
    return (await p.getAssetListPaged(page: 0, size: 1)).first;
  }
}

class GetImageExifUseCase implements BaseUseCase<Map<String, String>?, AssetEntity> {
  final PhotoRepository repo;

  GetImageExifUseCase({required this.repo});

  @override
  Future<Map<String, String>?> invoke(AssetEntity p) {
    return repo.getExif(p);
  }
}

class GetFileUseCase implements BaseUseCase<File?, AssetEntity>{
  final PhotoRepository repo;

  GetFileUseCase({required this.repo});

  @override
  Future<File?> invoke(AssetEntity p) {
    return repo.getFile(p);
  }
}

class CheckPermissionUseCase implements BaseUseCase<PermissionState, void>{
  final AlbumRepository repo;

  CheckPermissionUseCase({required this.repo});

  @override
  Future<PermissionState> invoke(void p) {
    return repo.checkPermission();
  }
}
