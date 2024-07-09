

class AlbumPermissionState{
  final bool isAuth;

  AlbumPermissionState copyWith({
    bool? isAuth,
  }) {
    return AlbumPermissionState(
      isAuth: isAuth ?? this.isAuth,
    );
  }

  AlbumPermissionState({
    required this.isAuth,
  });
}