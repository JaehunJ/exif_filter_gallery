import 'dart:io';

import 'package:exif_gallery/model/image_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';


class ImageViewScreen extends StatelessWidget {
  ImageModel entity;

  ImageViewScreen({super.key, required this.entity});

  void _shareFile() async {
    final file = await entity.getFile();
    if(file != null){
      final files = <XFile>[];
      files.add(XFile(file.path));
      await Share.shareXFiles(files);
    //   final list = [file.uri.toString()];
    //   Share.shareFiles(list);
    }
  }

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
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          print('a');
                          _shareFile();
                        }, icon: Icon(Icons.share, color: Colors.white,))
                      ],),
                  ),
                  Positioned(child: ExifInfoWidget(entity)),
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
  @override
  void initState() {
    super.initState();
    // widget.imageModel.getExifToPrint();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      child: Table(
        children: [
          TableRow(
            children: [
              Text('model', style: TextStyle(color: Colors.white),),
              Text('${widget.imageModel.make} ${widget.imageModel.model}', style: TextStyle(color: Colors.white),),
            ]
          ),
          TableRow(
              children: [
                Text('iso', style: TextStyle(color: Colors.white),),
                Text('${widget.imageModel.iso}', style: TextStyle(color: Colors.white),),
              ]
          ),
          TableRow(
              children: [
                Text('fNumber', style: TextStyle(color: Colors.white),),
                Text('${widget.imageModel.fNumber}', style: TextStyle(color: Colors.white),),
              ]
          ),
          TableRow(
              children: [
                Text('shutter speed', style: TextStyle(color: Colors.white),),
                Text('${widget.imageModel.exposureTime} ', style: TextStyle(color: Colors.white),),
              ]
          ),
          TableRow(
              children: [
                Text('focal Length', style: TextStyle(color: Colors.white),),
                Text('${widget.imageModel.focalLength} mm', style: TextStyle(color: Colors.white),),
              ]
          ),
        ],
      )
    );
  }
}
