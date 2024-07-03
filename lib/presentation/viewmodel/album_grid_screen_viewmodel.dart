

import 'dart:async';

import 'package:exif_gallery/di/usecase_provider.dart';
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
class AlbumGridScreenViewModel extends _$AlbumGridScreenViewModel{

  @override
  FutureOr<AlbumGridViewState> build(){
    return AlbumGridViewState(list: [], isAuth: false);
  }

  Future<bool> checkPermission() async{
    final state = await ref.watch(checkPermissionUseCaseProvider).invoke(null);

    return state.isAuth;
  }
}