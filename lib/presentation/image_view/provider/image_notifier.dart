import 'package:exif_gallery/di/injector.dart';
import 'package:exif_gallery/domain/usecase/usecase.dart';
import 'package:exif_gallery/model/image_grid_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'image_state.dart';

part 'image_notifier.g.dart';

@riverpod
class ImageNotifier extends _$ImageNotifier {
  final getFileUseCase = injector.get<GetFileUseCase>();
  @override
  FutureOr<ImageState> build(ImageGridModel model) async {
    final file = await getFileUseCase.invoke(model.entity);

    return ImageState(entity: model, file: file);
  }

}
