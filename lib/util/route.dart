
import 'dart:io';

import 'package:exif_gallery/screen/album_grid_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../screen/image_grid_screen.dart';
import '../screen/image_view_screen.dart';

// final GoRouter myRoute = GoRouter(routes: [
//   GoRoute(path: '/', builder: (context, state)=>AlbumGridScreen()),
//   GoRoute(path: '/image_view', builder: (context, state)=>ImageViewScreen())
// ]);

final GoRouter myRoute = GoRouter(routes: [
  GoRoute(path: Destination.home.path, builder: (context, state)=>AlbumGridScreen()),
  GoRoute(path: Destination.image_grid.path, builder: (context, state){
    return ImageGridScreen(albumData: state.extra as AssetPathEntity);
  }),
  GoRoute(path: Destination.image_view.path, builder: (context, state){
    return ImageViewScreen(file: state.extra as File,);
  })
]);

enum Destination{
  home('/'),
  image_grid('/image_grid'),
  image_view('/image_view');

  final String path;

  const Destination(this.path);
}