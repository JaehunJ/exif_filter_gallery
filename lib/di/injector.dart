import 'package:exif_gallery/data/repository/album_repository.dart';
import 'package:exif_gallery/domain/repository/album_repository_impl.dart';
import 'package:exif_gallery/domain/repository/photo_repository_impl.dart';
import 'package:get_it/get_it.dart';

import '../data/repository/photo_repository.dart';
import '../domain/usecase/usecase.dart';

final injector = GetIt.instance;

void provideRepository() {
  injector.registerFactory<AlbumRepository>(() => AlbumRepositoryImpl());
  injector.registerFactory<PhotoRepository>(() => PhotoRepositoryImpl());
}

void provideUseCase(){
  injector.registerFactory(()=>GetAlbumListUseCase(repo: injector.get<AlbumRepository>()));
  injector.registerFactory(()=>GetImageListUseCase(repo: injector.get<PhotoRepository>()));
  injector.registerFactory(()=>GetImageFirstUseCase(repo: injector.get<PhotoRepository>()));
  injector.registerFactory(()=>GetImageExifUseCase(repo: injector.get<PhotoRepository>()));
  injector.registerFactory(()=>GetFileUseCase(repo: injector.get<PhotoRepository>()));
  injector.registerFactory(()=>CheckPermissionUseCase(repo: injector.get<AlbumRepository>()));
}
