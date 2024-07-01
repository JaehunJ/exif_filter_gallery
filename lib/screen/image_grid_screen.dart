import 'package:exif_gallery/model/album_model.dart';
import 'package:exif_gallery/model/image_model.dart';
import 'package:exif_gallery/util/Constant.dart';
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
  late Future<List<ImageModel>> future;
  Filter currentFilter = Filter.DATE_ASC;
  bool enableExifFilter = false;
  int filterCnt = 0;

  @override
  void initState() {
    super.initState();
    // if (images == null) {
    //   _getImageList();
    // }

    future = _getImageListFuture();
  }

  Future<List<ImageModel>> _getImageListFuture() async {
    final t = await widget.albumData.getImageList();
    final List<ImageModel> list = [];
    for (var item in t) {
      final addedItem = ImageModel(item);
      // await addedItem.getExif();
      list.add(addedItem);
    }
    images = list;
    _getExifInfoFromList();
    return list;
  }

  void _getExifInfoFromList() async {
    final images = this.images;
    int cnt = 0;
    if (images != null) {
      for (var item in images) {
        await item.getExif();
        cnt++;

        setState(() {
          filterCnt = cnt;
        });
      }

      setState(() {
        enableExifFilter = true;
      });
    }
  }

  Widget _popup(bool enable) {
    return PopupMenuButton<Filter>(itemBuilder: (context) {
      return [
        _menuItem(Filter.DATE_ASC),
        _menuItem(Filter.DATE_DESC),
        _menuItem(Filter.MODEL, enable: enable),
        _menuItem(Filter.FOCAL_LENGTH, enable: enable)
      ];
    });
  }

  PopupMenuItem<Filter> _menuItem(Filter filter, {bool enable = true}) {
    return PopupMenuItem(
      child: Text(
        filter.value,
        style: TextStyle(color: enable ? Colors.black : Colors.grey),
      ),
      onTap: () {
        if (enable) {
          _sortImages(filter);
        }
      },
    );
  }

  void _sortImages(Filter filter) {
    final images = this.images;
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

      setState(() {
        this.images = images;
        currentFilter = filter;
      });
    }
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
          actions: [_popup(enableExifFilter)],
          // actions: [IconButton(onPressed: () {
          //   //filter
          //
          // }, icon: Icon(Icons.more_horiz))],
        ),
        body: FutureBuilder<List<ImageModel>>(
          future: future,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(children: [
                Visibility(
                  visible: !enableExifFilter,
                  // visible: true,
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
                          value: filterCnt / images!.length,
                        )),
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                        ),
                        Text("${filterCnt}/${images!.length}"),
                      ]),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            elevation: 0,
                            child: ImageGridItem(
                                entity: images![iter],
                                info: images![iter]
                                    .getFilterString(currentFilter)),
                          );
                        }),
                  ),
                ),
              ]);
            }
          },
        ));
  }
}

class ImageGridItem extends StatefulWidget {
  ImageModel entity;
  String info;

  ImageGridItem({super.key, required this.entity, required this.info});

  @override
  State<ImageGridItem> createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  late Future<bool> future;

  @override
  void initState() {
    super.initState();

    future = _getImage();
  }

  Future<bool> _getImage() async {
    return widget.entity.getExif();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            if (snapshot.data == true) {
              return GestureDetector(
                  onTap: () {
                    context.push(Destination.image_view.path,
                        extra: widget.entity);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AssetEntityImage(
                          widget.entity.getAsset(),
                          isOriginal: false,
                          thumbnailSize: const ThumbnailSize.square(200),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text(widget.info,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
            } else {
              return Container();
            }
          }
        });
  }
}

class ImageGridPopupMenu extends StatelessWidget {
  const ImageGridPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
