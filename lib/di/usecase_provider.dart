import 'package:exif_gallery/di/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/usecase/usecase.dart';

part 'usecase_provider.g.dart';

@riverpod
GetAlbumListUseCase getAlbumListUseCase(GetAlbumListUseCaseRef ref) =>
    GetAlbumListUseCase(repo: ref.watch(albumRepositoryProvider));

@riverpod
GetImageListUseCase getImageListUseCase(GetImageListUseCaseRef ref) =>
    GetImageListUseCase(repo: ref.watch(photoRepositoryProvider));

@riverpod
GetImageFirstUseCase getImageFirstUseCase(GetImageFirstUseCaseRef ref) =>
    GetImageFirstUseCase(repo: ref.watch(photoRepositoryProvider));

@riverpod
GetImageExifUseCase getImageExifUseCase(GetImageExifUseCaseRef ref) =>
    GetImageExifUseCase(repo: ref.watch(photoRepositoryProvider));

@riverpod
CheckPermissionUseCase checkPermissionUseCase(CheckPermissionUseCaseRef ref) =>
    CheckPermissionUseCase(repo: ref.watch(albumRepositoryProvider));
