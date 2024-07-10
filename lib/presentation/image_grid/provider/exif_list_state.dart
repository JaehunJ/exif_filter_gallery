

class ExifListState{
  final int cnt;
  final bool isDone;

  const ExifListState({
    required this.cnt,
    required this.isDone,
  });

  ExifListState copyWith({
    int? cnt,
    bool? isDone,
  }) {
    return ExifListState(
      cnt: cnt ?? this.cnt,
      isDone: isDone ?? this.isDone,
    );
  }
}