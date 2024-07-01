import 'package:exif_gallery/util/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../model/album_model.dart';

class AlbumGridScreen extends StatefulWidget {
  const AlbumGridScreen({super.key});

  @override
  State<AlbumGridScreen> createState() => _AlbumGridScreenState();
}

class _AlbumGridScreenState extends State<AlbumGridScreen> {
  List<AlbumModel>? _albumList;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    // Permission.
    final access = await PhotoManager.requestPermissionExtend();

    if (access.isAuth) {
      await _getAlbumInfo();
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> _getAlbumInfo() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    final List<AlbumModel> albumsList = [];

    for (var item in albums) {
      final addedItem = AlbumModel(item);
      await addedItem.getFirstImageEntity();
      albumsList.add(addedItem);
    }

    setState(() {
      _albumList = albumsList;
      print("done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exif Gallery"),
      ),
      body: _albumList == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 1,
                      crossAxisCount: 3),
                  itemCount: _albumList!.length,
                  itemBuilder: (context, iter) {
                    final item = _albumList![iter];
                    return AlbumGridCard(item);
                  }),
            ),
    );
  }
}

//
class AlbumGridCard extends StatelessWidget {
  const AlbumGridCard(this.data, {super.key});

  final AlbumModel data;

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
                    side: BorderSide(width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 0,
                child: data.firstImageEntity == null
                    ? Container()
                    : AlbumGridItem(
                        firstAsset: data.firstImageEntity!,
                      ),
              )),
          Container(
            child: Text(
              data.getAlbumName(),
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
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
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(200),
        fit: BoxFit.cover);
  }
}
