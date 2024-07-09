
import '../../../model/album_grid_model.dart';

class AlbumListState{
  List<AlbumGridModel> list;

  AlbumListState({
    required this.list,
  });

  AlbumListState copyWith({
    List<AlbumGridModel>? list,
  }) {
    return AlbumListState(
      list: list ?? this.list,
    );
  }
}