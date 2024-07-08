import 'package:exif_gallery/model/album_grid_model.dart';
import 'package:exif_gallery/presentation/viewmodel/album_grid_screen_viewmodel.dart';
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
    final viewModel = ref.read(albumGridScreenViewModelProvider.notifier);
    final state = ref.watch(albumGridScreenViewModelProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text("Exif Gallery"),
        ),
        body: state.when(
            data: (data) {
              if (!data.isAuth) {
                viewModel.checkPermission();
                return SizedBox();
              } else {
                if(data.list.isEmpty){
                  Future((){
                    viewModel.getAlbumList();
                  });
                  return const Center(child: Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                    CircularProgressIndicator(),
                    Text('앨범 정보 읽는 중')
                  ],));
                }else{
                  return gridWidget(data.list);
                }
              }
            },
            error: (e, m) {
              return Text('레전드 상황 발생');
            },
            loading: () => const Center(child: CircularProgressIndicator(),))
        );
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
