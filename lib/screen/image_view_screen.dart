import 'dart:io';

import 'package:exif/exif.dart';
import 'package:exif_gallery/model/image_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  ImageModel entity;

  ImageViewScreen({super.key, required this.entity});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: FutureBuilder<File?>(
          future: entity.getFile(),
          builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            } else {
              return Stack(
                children: [
                  PhotoView(
                    imageProvider: FileImage(snapshot.data!),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ExifInfoWidget(entity))
                ],
              );
            }
          },
        ));
  }
}

class ExifInfoWidget extends StatefulWidget {
  ImageModel imageModel;

  ExifInfoWidget(this.imageModel, {super.key});

  @override
  State<ExifInfoWidget> createState() => _ExifInfoWidgetState();
}

class _ExifInfoWidgetState extends State<ExifInfoWidget> {
  // Map<String, IfdTag> datas = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getExifData();
  }
  //
  // void _getExifData() async {
  //   final data = await readExifFromFile(widget.file);
  //
  //   setState(() {
  //     final list = data.entries.where((e){
  //       // return e.key.contains("EXIF");
  //       return true;
  //     });
  //
  //     for (final entry in list) {
  //       print("${entry.key}: ${entry.value}");
  //     }
  //
  //     datas.addEntries(list);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.amber),
        child: Text(
          widget.imageModel.focalLength,
        ));
  }
}

// class ExifInfoModel{
//   final String focalLength;
//   final cameraModel;
//   ExifInfoModel();
// }

