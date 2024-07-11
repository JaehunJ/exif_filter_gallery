import 'package:exif_gallery/model/album_grid_model.dart';
import 'package:exif_gallery/presentation/album_grid/provider/album_list_notifier.dart';
import 'package:exif_gallery/presentation/album_grid/provider/album_permission_notifier.dart';
import 'package:exif_gallery/util/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AlbumGridScreen extends ConsumerStatefulWidget {
  const AlbumGridScreen({super.key});

  @override
  ConsumerState<AlbumGridScreen> createState() => _AlbumGridScreenState();
}

class _AlbumGridScreenState extends ConsumerState<AlbumGridScreen> {
  Widget gridWidget(List<AlbumGridModel> list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5, childAspectRatio: 0.8, crossAxisSpacing: 1, crossAxisCount: 3),
          itemCount: list.length,
          itemBuilder: (context, iter) {
            final item = list[iter];
            return AlbumCard(item);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permissionState = ref.watch(albumPermissionNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text("Exif Gallery"),
        ),
        body: permissionState.when(
            data: (data) {
              if (!data.isAuth) {
                Future(() async {
                  await PhotoManager.openSetting();
                });
                return const SizedBox();
              } else {
                final albumListState = ref.watch(albumListNotifierProvider);
                return albumListState.when(
                    data: (listData) {
                      return gridWidget(listData.list);
                    },
                    error: (e, m) => Text('레전드 상황 발생'),
                    loading: () => CircularProgressIndicator());
              }
            },
            error: (error, message) => Text('레전드 상황 발생'),
            loading: () => const CircularProgressIndicator()));
  }
}

//
class AlbumCard extends StatelessWidget {
  const AlbumCard(this.data, {super.key});

  final AlbumGridModel data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Destination.image_grid.path, extra: data);
      },
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10))),
                  elevation: 0,
                  child: AlbumGridItem(
                    firstAsset: data.first,
                  ))),
          Container(
            child: Text(
              data.albumName,
              style: TextStyle(fontSize: 15, color: Colors.black, overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    );
  }
}

class AlbumGridItem extends StatelessWidget {
  AssetEntity firstAsset;

  AlbumGridItem({super.key, required this.firstAsset});

  @override
  Widget build(BuildContext context) {
    return AssetEntityImage(firstAsset,
        isOriginal: false, thumbnailSize: const ThumbnailSize.square(200), fit: BoxFit.cover);
  }
}
