import 'package:exif_gallery/model/album_grid_model.dart';
import 'package:exif_gallery/model/image_grid_model.dart';
import 'package:exif_gallery/presentation/image_grid/provider/exif_list_notifier.dart';
import 'package:exif_gallery/presentation/image_grid/provider/image_list_notifier.dart';
import 'package:exif_gallery/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../util/route.dart';


class ImageGridScreen extends ConsumerWidget {
  ImageGridScreen({super.key, required this.albumData});

  AlbumGridModel albumData;

  Widget _popup(bool enable, {required Function(Filter) onTab}) {
    return PopupMenuButton<Filter>(itemBuilder: (context) {
      return [
        _menuItem(Filter.DATE_ASC, onTab),
        _menuItem(Filter.DATE_DESC, onTab),
        _menuItem(Filter.MODEL, onTab, enable: enable),
        _menuItem(Filter.FOCAL_LENGTH, onTab, enable: enable)
      ];
    });
  }

  PopupMenuItem<Filter> _menuItem(Filter filter, Function(Filter) onTap, {bool enable = true}) {
    return PopupMenuItem(
      child: Text(
        filter.value,
        style: TextStyle(color: enable ? Colors.black : Colors.grey),
      ),
      onTap: () {
        if (enable) {
          onTap(filter);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final length = ref.watch(imageListNotifierProvider.call(albumData.entity).select((selector) {
      return selector.value?.images.length ?? 0;
    }));
    final notifier = ref.watch(imageListNotifierProvider.call(albumData.entity).notifier);
    final exifDone = ref.watch(exifListNotifierProvider.select((selector) => selector.value?.isDone ?? false));

    return Scaffold(
        appBar: AppBar(
          title: Text(albumData.albumName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
            _popup(exifDone, onTab: (filter) {
              notifier.changeFilter(filter);
            })
          ],
        ),
        body: Column(
          children: [
            ExifCountProgressBarWidget(length: length),
            ImageGridBodyPage(
              entity: albumData.entity,
            )
          ],
        ));
  }
}

class ExifCountProgressBarWidget extends ConsumerWidget {
  final int length;

  const ExifCountProgressBarWidget({required this.length, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exifListNotifierProvider);

    return state.when(
        data: (data) {
          return Visibility(
              visible: !data.isDone,
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Text("Exif info"),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                    ),
                    Expanded(
                        child: LinearProgressIndicator(
                      value: data.cnt / length,
                    )),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                    ),
                    Text("${data.cnt}/$length"),
                  ]),
                ),
              ));
        },
        error: (e, m) {
          return Text('레전드 상황 발생');
        },
        loading: () => SizedBox());
  }
}

class ImageGridBodyPage extends ConsumerWidget {
  final AssetPathEntity entity;

  const ImageGridBodyPage({required this.entity, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageListNotifierProvider.call(entity));

    return state.when(
        data: (data) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 1, crossAxisSpacing: 1, crossAxisCount: 3),
                  itemCount: data.images.length,
                  itemBuilder: (context, iter) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10))),
                      elevation: 0,
                      child: ImageGridItem(
                          model: data.images[iter], info: data.images[iter].getFilterString(data.currentFilter)),
                    );
                  }),
            ),
          );
        },
        error: (e, m) {
          return Text('레전드 상황 발생');
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}

class ImageGridItem extends StatelessWidget {
  final ImageGridModel model;
  final info;

  ImageGridItem({super.key, required this.model, required this.info});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.push(Destination.image_view.path, extra: model);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: AssetEntityImage(
                model.entity,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(200),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(info,
                        style: const TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
