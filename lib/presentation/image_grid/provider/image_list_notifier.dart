import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:exif_gallery/model/image_grid_model.dart';
import 'package:exif_gallery/presentation/image_grid/provider/image_list_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/constant.dart';

part 'image_list_notifier.g.dart';

@riverpod
class ImageListNotifier extends _$ImageListNotifier {
  final getImageListUseCase = injector.get<GetImageListUseCase>();

  @override
  FutureOr<ImageListState> build(AssetPathEntity p) async {
    final result = await getImageListUseCase.invoke(p);
    final list = <ImageGridModel>[];

    for (final item in result) {
      list.add(ImageGridModel(entity: item));
    }

    return ImageListState(images: list, currentFilter: Filter.DATE_ASC);
  }

  int getImageListLength() => state.value?.images.length ?? 0;

  void changeFilter(Filter filter) {
    _sortList(filter);
  }

  void _sortList(Filter filter) {
    final stateValue = state.value;
    if (stateValue != null) {
      final list = stateValue.images;
      list.sort((a, b) {
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

      state = AsyncData(stateValue.copyWith(images: list, currentFilter: filter));
    }
  }
}
