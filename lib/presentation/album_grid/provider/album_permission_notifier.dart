

import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:exif_gallery/presentation/album_grid/provider/album_permission_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_permission_notifier.g.dart';

@riverpod
class AlbumPermissionNotifier extends _$AlbumPermissionNotifier{
  final checkPermissionUseCase = injector.get<CheckPermissionUseCase>();
  @override
  Future<AlbumPermissionState> build() async {
    final value = (await checkPermissionUseCase.invoke(null)).isAuth;
    return AlbumPermissionState(isAuth: value);
  }
}