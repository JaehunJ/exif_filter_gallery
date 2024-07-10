

import '../../../model/image_grid_model.dart';
import '../../../util/constant.dart';

class ImageListState{
  List<ImageGridModel> images;
  Filter currentFilter = Filter.DATE_ASC;

  ImageListState({
    required this.images,
    required this.currentFilter,
  });

  ImageListState copyWith({
    List<ImageGridModel>? images,
    Filter? currentFilter,
  }) {
    return ImageListState(
      images: images ?? this.images,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}