import 'dart:io';

import 'package:exif_gallery/util/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';


class AlbumGridScreen extends StatefulWidget {
  const AlbumGridScreen({super.key});

  @override
  State<AlbumGridScreen> createState() => _AlbumGridScreenState();
}

class _AlbumGridScreenState extends State<AlbumGridScreen> {
  List<AssetPathEntity>? _albums;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    final access = await PhotoManager.requestPermissionExtend();

    if (access.isAuth) {
      _getAlbumInfo();
    } else {
      PhotoManager.openSetting();
    }
  }

  void _getAlbumInfo() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    setState(() {
      _albums = albums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exif Gallery"),
      ),
      body: _albums == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3),
                  itemCount: _albums!.length,
                  itemBuilder: (context, iter) {
                    return AlbumGridCard(
                      _albums![iter],
                    );
                  }),
            ),
    );
  }
}

class AlbumGridCard extends StatelessWidget {
  const AlbumGridCard(AssetPathEntity this.data, {super.key});

  final AssetPathEntity data;

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
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 2, color: Colors.black26),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: AlbumGridItem(
                    asset: data,
                  ),
                )),
          ),
          Container(
            child: Text(
              data.name,
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

class AlbumGridItem extends StatefulWidget {
  final AssetPathEntity asset;

  const AlbumGridItem({super.key, required this.asset});

  @override
  State<AlbumGridItem> createState() => _AlbumGridItemState();
}

class _AlbumGridItemState extends State<AlbumGridItem> {
  // AssetEntity? _firstAsset;
  File? file;

  @override
  void initState() {
    super.initState();
    _loadFirstAsset();
  }

  Future<void> _loadFirstAsset() async {
    final list = await _getFirstAsset();
    final first = await list.first.file;

    if(first!=null){
      print(first.path);
    }

    if(list.isNotEmpty){
      setState(() {
        // _firstAsset = list.first;
        file = first;
      });
    }
  }

  Future<List<AssetEntity>> _getFirstAsset() async{
    final cnt = await widget.asset.assetCountAsync;

    return widget.asset.getAssetListPaged(page: 0, size: cnt);
  }

  @override
  Widget build(BuildContext context) {
    return file != null
        ? PhotoView(imageProvider: FileImage(file!))
        : Container();
  }
}
