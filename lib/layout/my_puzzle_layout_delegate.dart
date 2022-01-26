import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/puzzle_theme/bloc/puzzle_theme_bloc.dart';
import 'package:very_good_slide_puzzle/simple/simple.dart';

/// {@template simple_puzzle_layout_delegate}
/// My own version of delegate for computing the layout of the puzzle UI.
/// {@endtaplate}
class MyPuzzleLayoutDelegate extends SimplePuzzleLayoutDelegate {
  /// {@macro my_puzzle_layout_delegate}
  const MyPuzzleLayoutDelegate();

  @override
  Widget tileThemedBuilder(
    Tile tile,
    PuzzleState state,
    PuzzleThemeState puzzleThemeState,
  ) {
    final isReadyToDisplayImg =
            state.tileCount == puzzleThemeState.splitImageCount &&
                !puzzleThemeState.isLoading,
        bgImagesBytes = isReadyToDisplayImg
            ? puzzleThemeState.splitImageList[tile.value - 1]
            : null;
    return ResponsiveLayoutBuilder(
      small: (_, __) => MyPuzzleTile(
        key: Key('my_puzzle_tile_${tile.value}_small'),
        tile: tile,
        state: state,
        bgImageBytes: bgImagesBytes,
      ),
      medium: (_, __) => MyPuzzleTile(
        key: Key('my_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        state: state,
        bgImageBytes: bgImagesBytes,
      ),
      large: (_, __) => MyPuzzleTile(
        key: Key('my_puzzle_tile_${tile.value}_large'),
        tile: tile,
        state: state,
        bgImageBytes: bgImagesBytes,
      ),
    );
  }
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// Tile background should displayed an image based on [bgImageBytes].
/// If no [bgImageBytes] is given, it displays a [CircularProgressIndicator].
/// {@endtemplate}
class MyPuzzleTile extends StatelessWidget {
  /// {@macro my_puzzle_tile}
  const MyPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
    this.bgImageBytes,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  /// The background image.
  final Uint8List? bgImageBytes;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(13);
    return Material(
      borderRadius: borderRadius,
      elevation: 2,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: state.puzzleStatus == PuzzleStatus.incomplete
            ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
            : null,
        child: bgImageBytes != null
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(bgImageBytes!),
                  ),
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
