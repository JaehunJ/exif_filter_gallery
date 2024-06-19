import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

import '../util/route.dart';

class ImageGridScreen extends StatefulWidget {
  ImageGridScreen({super.key, required this.albumData});

  AssetPathEntity? albumData;

  @override
  State<ImageGridScreen> createState() => _ImageGridScreenState(albumData);
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  AssetPathEntity? albumData;
  List<AssetEntity>? images;

  _ImageGridScreenState(AssetPathEntity? albumData){
    this.albumData = albumData;
  }

  @override
  void initState() {
    super.initState();
    _getImageList();
  }

  void _getImageList() async {
    final count = await albumData?.assetCountAsync ?? 0;

    if (count != 0) {
      final t = await albumData?.getAssetListRange(start: 0, end: count);
      setState(() {
        images = t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albumData?.name ?? ''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
        ],
      ),
      body: (images == null || images!.isEmpty) ? const Center(
          child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5, crossAxisSpacing: 5,
                crossAxisCount: 3),
            itemCount: images!.length,
            itemBuilder: (context, iter) {
              return ImageGrid(entity: images![iter],);
            }),
      ),);
  }
}


// class ImageGridScreen extends StatelessWidget {
//   ImageGridScreen({super.key, required this.albumData});
//
//   AssetPathEntity? albumData;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(albumData!.name),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: (){
//             context.pop();
//           },
//         ),
//         actions: [
//           IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
//         ],
//       ),
//     body: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 10, crossAxisSpacing: 10,
//               crossAxisCount: 3),
//           itemCount: 40,
//           itemBuilder: (context, iter) {
//             return ImageGrid();
//           }),
//     ),);
//   }
// }

class ImageGrid extends StatefulWidget {
  AssetEntity entity;

  ImageGrid({super.key, required this.entity});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  File? file;

  @override
  void initState() {
    super.initState();
    _getFile();
  }

  void _getFile() async {
    final f = widget.entity.file;
    
    f.then((_file){
      setState(() {
        file = _file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Destination.image_view.path, extra: file);
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 2, color: Colors.black26),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: file == null ? Icon(Icons.access_time):PhotoView(imageProvider: FileImage(file!)),
          )),
    );
  }
}


// class ImageGrid extends StatelessWidget {
//   const ImageGrid({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         context.push(Destination.image_view.path);
//       },
//       child: Container(
//           decoration: BoxDecoration(
//               color: Colors.grey,
//               border: Border.all(width: 2, color: Colors.black26),
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: Center(
//             child: Icon(Icons.access_time),
//           )),
//     );
//   }
// }

