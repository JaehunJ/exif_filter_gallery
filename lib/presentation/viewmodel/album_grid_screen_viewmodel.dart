import 'dart:async';

import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/album_grid_model.dart';

part 'album_grid_screen_viewmodel.g.dart';

class AlbumGridViewState {
  List<AlbumGridModel> list;
  bool isAuth;

  AlbumGridViewState({required this.list, required this.isAuth});

  AlbumGridViewState copyWidth({List<AlbumGridModel>? list, bool? isAuth}) {
    return AlbumGridViewState(list: list ?? this.list, isAuth: isAuth ?? this.isAuth);
  }
}

@riverpod
class AlbumGridScreenViewModel extends _$AlbumGridScreenViewModel {
  final _getAlbumListUseCase = injector.get<GetAlbumListUseCase>();
  final _getImageFirstUseCase = injector.get<GetImageFirstUseCase>();
  final _checkPermissionUseCase = injector.get<CheckPermissionUseCase>();

  @override
  FutureOr<AlbumGridViewState> build() {
    return AlbumGridViewState(list: [], isAuth: false);
  }

  Future<void> getAlbumList() async {
    final result = await _getAlbumList();
    final List<AlbumGridModel> list = [];

    for (final item in result) {
      final first = await _getFirstAssetFromAlbum(item);
      final name = item.name;
      list.add(AlbumGridModel(entity: item, first: first, albumName: name));
    }

    state = AsyncData(state.value!.copyWidth(list: list));
  }

  Future<List<AssetPathEntity>> _getAlbumList() async {
    return _getAlbumListUseCase.invoke(null);
  }

  Future<AssetEntity> _getFirstAssetFromAlbum(AssetPathEntity entity) async{
    return await _getImageFirstUseCase.invoke(entity);
  }

  void checkPermission() async {
    if(state.hasValue){
      if(state.value!.isAuth){
        return;
      }

      final authState = await _checkPermissionUseCase.invoke(null);

      state = AsyncData(state.value!.copyWidth(isAuth: authState.isAuth));
    }
  }
}
