// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_slide_puzzle/layout/my_puzzle_layout_delegate.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/puzzle_theme/bloc/puzzle_theme_bloc.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

import '../helpers/helpers.dart';
import '../helpers/mocks.dart';
import '../helpers/pump_app.dart';
import '../helpers/set_display_size.dart';

void main() {
  group('MyPuzzleLayoutDelegate', () {
    const delegate = MyPuzzleLayoutDelegate();

    group('tileThemedBuilder', () {
      late Tile tile;
      late PuzzleState state;
      late PuzzleThemeState puzzleThemeState;
      late ThemeBloc themeBloc;
      const tileValue = 10;

      setUp(() {
        tile = MockTile();
        themeBloc = MockThemeBloc();
        state = MockPuzzleState();
        puzzleThemeState = MockPuzzleThemeState();
        when(() => tile.value).thenReturn(tileValue);

        when(() => state.puzzleStatus).thenReturn(PuzzleStatus.incomplete);
        when(() => state.numberOfMoves).thenReturn(5);
        when(() => state.numberOfTilesLeft).thenReturn(15);
        when(() => state.tileCount).thenReturn(9);

        when(() => puzzleThemeState.splitImageCount).thenReturn(9);
        when(() => puzzleThemeState.isLoading).thenReturn(true);
      });

      testWidgets(
          'renders a large puzzle tile '
          'on a large display', (tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          delegate.tileThemedBuilder(tile, state, puzzleThemeState),
          themeBloc: themeBloc,
        );

        expect(
          find.byKey(Key('my_puzzle_tile_${tileValue}_large')),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders a medium puzzle tile '
          'on a medium display', (tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          delegate.tileThemedBuilder(tile, state, puzzleThemeState),
          themeBloc: themeBloc,
        );

        expect(
          find.byKey(Key('my_puzzle_tile_${tileValue}_medium')),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders a small puzzle tile '
          'on a small display', (tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          delegate.tileThemedBuilder(tile, state, puzzleThemeState),
          themeBloc: themeBloc,
        );

        expect(
          find.byKey(Key('my_puzzle_tile_${tileValue}_small')),
          findsOneWidget,
        );
      });

      testWidgets(
          'should not render a CircularProgressIndicator if '
          'states tile count match & is not loading.', (tester) async {
        when(() => tile.value).thenReturn(1);
        when(() => puzzleThemeState.isLoading).thenReturn(false);
        when(() => puzzleThemeState.splitImageList).thenReturn(
          [uInt8ListExample],
        );

        tester.setSmallDisplaySize();

        await tester.pumpApp(
          delegate.tileThemedBuilder(tile, state, puzzleThemeState),
          themeBloc: themeBloc,
        );

        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });
  });

  group('MyPuzzleTile', () {
    final tile = MockTile(), puzzleState = MockPuzzleState();

    testWidgets(
        'Given an empty bgImageBytes '
        'it should render a CircularProgressIndicator.', (tester) async {
      when(() => puzzleState.puzzleStatus).thenReturn(PuzzleStatus.incomplete);
      await tester.pumpApp(
        MyPuzzleTile(
          tile: tile,
          state: puzzleState,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'state is incomplete, tap on the tile '
        'should trigger puzzleBloc.add(TileTapped).', (tester) async {
      final puzzleBloc = MockPuzzleBloc();
      when(() => puzzleState.puzzleStatus).thenReturn(PuzzleStatus.incomplete);
      await tester.pumpApp(
        MyPuzzleTile(tile: tile, state: puzzleState),
        puzzleBloc: puzzleBloc,
      );
      await tester.tap(find.byType(InkWell));
      verify(() => puzzleBloc.add(TileTapped(tile)));
    });
  });
}
