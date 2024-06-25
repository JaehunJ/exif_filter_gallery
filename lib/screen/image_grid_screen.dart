import 'package:exif_gallery/model/album_model.dart';
import 'package:exif_gallery/model/image_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../util/route.dart';

class ImageGridScreen extends StatefulWidget {
  ImageGridScreen({super.key, required this.albumData});

  AlbumModel albumData;

  @override
  State<ImageGridScreen> createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  List<ImageModel>? images;

  @override
  void initState() {
    super.initState();
    if (images == null) {
      _getImageList();
    }
  }

  void _getImageList() async {
    final t = await widget.albumData.getImageList();
    final List<ImageModel> list = [];
    for(var item in t){
      final addedItem = ImageModel(item);
      await addedItem.getExif();
      list.add(addedItem);
    }

    setState(() {
      images = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumData.getAlbumName()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: (images == null || images!.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      crossAxisCount: 3),
                  itemCount: images!.length,
                  itemBuilder: (context, iter) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      elevation: 0,
                      child: ImageGridItem(
                        entity: images![iter],
                      ),
                    );
                  }),
            ),
    );
  }
}

// class ImageGrid extends StatefulWidget {
//   AssetEntity entity;
//
//   ImageGrid({super.key, required this.entity});
//
//   @override
//   State<ImageGrid> createState() => _ImageGridState();
// }

class ImageGridItem extends StatelessWidget {
  final ImageModel entity;

  const ImageGridItem({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Destination.image_view.path, extra: entity);
      },
      child: AssetEntityImage(
        entity.entity,
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(200),
        fit: BoxFit.cover,
      ),
    );
  }
}

// class ImageGridItem extends StatelessWidget {
//   AssetEntity entity;
//
//   ImageGridItem({required this.entity, super.key})
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return GestureDetector(
//   //       onTap: () {
//   //         context.push(Destination.image_view.path, extra: entity);
//   //       },
//   //
//   //   );
//   // }
//
//
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return AssetEntityImage(entity,
//   //       isOriginal: false,
//   //       thumbnailSize: const ThumbnailSize.square(200),
//   //       fit: BoxFit.cover);
//   // }
// }
