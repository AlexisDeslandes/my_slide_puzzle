// ignore_for_file: public_member_api_docs
part of 'puzzle_theme_bloc.dart';

class PuzzleThemeState extends Equatable {
  const PuzzleThemeState({
    this.bgAssetImagePath = 'assets/images/flutter.png',
    this.splitImageList = const [],
    this.isLoading = false,
  });

  PuzzleThemeState copyWith({
    String? bgAssetImagePath,
    List<Uint8List>? splitImageList,
    bool? isLoading,
  }) =>
      PuzzleThemeState(
        bgAssetImagePath: bgAssetImagePath ?? this.bgAssetImagePath,
        splitImageList: splitImageList ?? this.splitImageList,
        isLoading: isLoading ?? this.isLoading,
      );

  /// Path to the image used as background,
  /// in our example it should be something like 'assets/images/***.png'.
  final String bgAssetImagePath;
  final List<Uint8List> splitImageList;
  final bool isLoading;

  int get splitImageCount => splitImageList.length;

  @override
  List<Object?> get props => [bgAssetImagePath, splitImageList, isLoading];
}
