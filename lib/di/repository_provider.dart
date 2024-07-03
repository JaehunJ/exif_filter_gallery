import 'package:exif_gallery/data/repository/album_repository.dart';
import 'package:exif_gallery/data/repository/photo_repository.dart';
import 'package:exif_gallery/domain/repository/album_repository_impl.dart';
import 'package:exif_gallery/domain/repository/photo_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_provider.g.dart';

@Riverpod(keepAlive: true)
AlbumRepository albumRepository(AlbumRepositoryRef ref) => AlbumRepositoryImpl();

@Riverpod(keepAlive: true)
PhotoRepository photoRepository(PhotoRepositoryRef ref) => PhotoRepositoryImpl();
