import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/puzzle_theme/puzzle_theme.dart';
import 'package:very_good_slide_puzzle/utils/utils.dart';

import '../../helpers/fakes.dart';
import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PuzzleThemeBloc', () {
    late PuzzleBloc puzzleBloc;
    late ImageUtils imageUtils;

    setUpAll(() {
      registerFallbackValue(FakeList<int>());
    });

    setUp(() {
      puzzleBloc = MockPuzzleBloc();
      imageUtils = MockImageUtils();
    });

    blocTest<PuzzleThemeBloc, PuzzleThemeState>(
      'SplitPuzzleTheme should emit one time with isLoading, '
      'and second time isLoading=false & with splitImageList filled.',
      build: () {
        when(() => imageUtils.cutInSquares(any(), 4))
            .thenReturn(List.filled(4, uInt8ListExample));
        return PuzzleThemeBloc(puzzleBloc: puzzleBloc, imageUtils: imageUtils);
      },
      act: (bloc) => bloc.add(const SplitPuzzleTheme(4)),
      expect: () => [
        const PuzzleThemeState(isLoading: true),
        PuzzleThemeState(splitImageList: List.filled(4, uInt8ListExample))
      ],
    );
  });
}
