import 'dart:async';

import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:exif_gallery/presentation/image_grid/provider/exif_list_state.dart';
import 'package:exif_gallery/presentation/image_grid/provider/image_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exif_list_notifier.g.dart';

@riverpod
class ExifListNotifier extends _$ExifListNotifier {
  final getExifUseCase = injector.get<GetImageExifUseCase>();

  @override
  FutureOr<ExifListState> build() async {
    return ExifListState(cnt: 0, isDone: false);
  }

  Stream<int> exportExifData(ImageListState imageList) async* {
    int cnt = 0;
    for (final item in imageList.images) {
      final result = await getExifUseCase.invoke(item.entity);
      if (result != null) {
        item.exifModel = result;
        state = AsyncData(state.value!.copyWith(cnt: ++cnt, isDone: false));
        yield cnt;
      }
    }
  }
}
