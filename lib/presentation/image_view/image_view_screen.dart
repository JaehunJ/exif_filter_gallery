import 'dart:io';

import 'package:exif_gallery/model/image_grid_model.dart';
import 'package:exif_gallery/presentation/image_view/provider/image_notifier.dart';
import 'package:exif_gallery/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ImageViewScreen extends ConsumerWidget {
  ImageGridModel entity;

  ImageViewScreen({super.key, required this.entity});

  void _shareFile() async {
    final file = await entity.entity.file;
    if (file != null) {
      final files = <XFile>[];
      files.add(XFile(file.path));
      await Share.shareXFiles(files);
      //   final list = [file.uri.toString()];
      //   Share.shareFiles(list);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(imageViewModelProvider);
    final state = ref.watch(imageNotifierProvider.call(entity));
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
        body: state.when(
            data: (data) {
              return Stack(
                children: [
                  PhotoView(imageProvider: FileImage(data.file ?? File(''))),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              print('a');
                              _shareFile();
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  Positioned(child: ExifInfoWidget(data.entity.exifModel)),
                ],
              );
            },
            error: (e, m) {
              return Text('레전드 상황 발생');
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ))
        );
  }
}

class ExifInfoWidget extends StatelessWidget {
  Map<String, String> exif;

  ExifInfoWidget(this.exif, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        child: Table(
          children: [
            TableRow(children: [
              Text(
                'model',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '${exif[Exif_Key.MAKE]} ${exif[Exif_Key.MODEL]}',
                style: TextStyle(color: Colors.white),
              ),
            ]),
            TableRow(children: [
              Text(
                'iso',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '${exif[Exif_Key.ISO]}',
                style: TextStyle(color: Colors.white),
              ),
            ]),
            TableRow(children: [
              Text(
                'fNumber',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'f${exif[Exif_Key.FNUMBER]}',
                style: TextStyle(color: Colors.white),
              ),
            ]),
            TableRow(children: [
              Text(
                'shutter speed',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '${exif[Exif_Key.SHUTTER_SPEED]} s',
                style: TextStyle(color: Colors.white),
              ),
            ]),
            TableRow(children: [
              Text(
                'focal Length',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '${exif[Exif_Key.FOCAL_LENGTH]} mm',
                style: TextStyle(color: Colors.white),
              ),
            ]),
          ],
        ));
  }
}
