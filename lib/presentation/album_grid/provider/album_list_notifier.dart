import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/album_grid_model.dart';
import 'album_list_state.dart';

part 'album_list_notifier.g.dart';

@riverpod
class AlbumListNotifier extends _$AlbumListNotifier {
  final getAlbumListUseCase = injector.get<GetAlbumListUseCase>();
  final getAlbumFirstImageUseCase = injector.get<GetImageFirstUseCase>();

  Future<AlbumListState> build() async {
    final result = await getAlbumListUseCase.invoke(null);
    final List<AlbumGridModel> list = [];

    for (final item in result) {
      final first = await getAlbumFirstImageUseCase.invoke(item);
      final name = item.name;
      list.add(AlbumGridModel(entity: item, first: first, albumName: name));
    }
    return AlbumListState(list: list);
  }
}
