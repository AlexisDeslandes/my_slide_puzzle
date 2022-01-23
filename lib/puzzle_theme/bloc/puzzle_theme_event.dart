// ignore_for_file: public_member_api_docs
part of 'puzzle_theme_bloc.dart';

abstract class PuzzleThemeEvent extends Equatable {
  const PuzzleThemeEvent();

  @override
  List<Object?> get props => [];
}

class SplitPuzzleTheme extends PuzzleThemeEvent {
  const SplitPuzzleTheme(this.count);

  final int count;
}
