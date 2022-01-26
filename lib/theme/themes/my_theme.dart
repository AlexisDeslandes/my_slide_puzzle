import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/layout/my_puzzle_layout_delegate.dart';
import 'package:very_good_slide_puzzle/simple/simple.dart';

/// {@template simple_theme}
/// An extension of the simple puzzle theme,
/// but it uses a background image and [MyPuzzleLayoutDelegate].
/// {@endtemplate}
class MyTheme extends SimpleTheme {
  ///
  const MyTheme();

  @override
  String get name => 'My theme';

  @override
  PuzzleLayoutDelegate get layoutDelegate => const MyPuzzleLayoutDelegate();

  @override
  bool get useBackgroundImage => true;
}
