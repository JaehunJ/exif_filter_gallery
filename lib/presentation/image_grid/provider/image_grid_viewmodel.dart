import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/image_grid_model.dart';
import '../../../util/constant.dart';

part 'image_grid_viewmodel.g.dart';

class ImageGridViewState {
  String albumName;
  List<ImageGridModel> images;
  Filter currentFilter = Filter.DATE_ASC;
  bool enableExifFilter = false;
  int exifCnt = 0;

  ImageGridViewState(
      {required this.albumName,
      required this.images,
      required this.currentFilter,
      required this.exifCnt,
      required this.enableExifFilter});

  ImageGridViewState copyWith(
      {String? albumName, List<ImageGridModel>? list, Filter? filter, int? exifCnt, bool? enableFilter}) {
    return ImageGridViewState(
        albumName: albumName ?? this.albumName,
        images: list ?? this.images,
        currentFilter: filter ?? this.currentFilter,
        exifCnt: exifCnt ?? this.exifCnt,
        enableExifFilter: enableFilter ?? this.enableExifFilter);
  }
}

@riverpod
class ImageGridViewModel extends _$ImageGridViewModel {
  final getImageListUseCase = injector.get<GetImageListUseCase>();
  final getImageExifUseCase = injector.get<GetImageExifUseCase>();

  /// return basic state
  @override
  FutureOr<ImageGridViewState> build() {
    return ImageGridViewState(
        albumName: "", images: [], currentFilter: Filter.DATE_ASC, exifCnt: 0, enableExifFilter: false);
  }

  Future<List<ImageGridModel>> getImages(AssetPathEntity album) async {
    final images = await getImageListUseCase.invoke(album);
    final List<ImageGridModel> list = [];

    for (final item in images) {
      list.add(ImageGridModel(entity: item));
    }

    return list;
  }

  Future<int> getExif() async {
    if (!state.hasValue) {
      final value = state.value;
      final list = value!.images;

      for (final item in list) {
        final result = await getImageExifUseCase.invoke(item.entity);

        if (result != null) {
          item.exifModel = result;

          state = AsyncData(state.value!.copyWith(exifCnt: state.value!.exifCnt + 1));
        }
      }
    }

    return 0;
  }

  double getExifProgress() {
    return (state.value?.exifCnt ?? 0) / (state.value?.images.length ?? 1);
  }

  void sortImages(Filter filter) {
    if(state.value != null){
      final images = state.value?.images;
      if (images != null) {
        images.sort((a, b) {
          if (filter == Filter.MODEL) {
            return a.compareMake(b);
          } else if (filter == Filter.FOCAL_LENGTH) {
            return a.compareFocalLength(b);
          } else if (filter == Filter.DATE_ASC) {
            return a.getDateTime().compareTo(b.getDateTime()) * -1;
          } else {
            return a.getDateTime().compareTo(b.getDateTime());
          }
        });

        state = AsyncData(state.value!.copyWith(list: images, filter: filter));
      }
    }
  }

}
