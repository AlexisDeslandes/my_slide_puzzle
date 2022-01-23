import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/utils/image_utils.dart';

part 'puzzle_theme_event.dart';

part 'puzzle_theme_state.dart';

/// A Bloc that subscribe to [PuzzleBloc] and depending on
/// the tile count. It split the puzzle background image so that
/// tiles will show different part of the puzzle depending on their number.
class PuzzleThemeBloc extends Bloc<PuzzleThemeEvent, PuzzleThemeState> {
  /// {@macro puzzle_theme_bloc}
  PuzzleThemeBloc({required PuzzleBloc puzzleBloc, ImageUtils? imageUtils})
      : _imageUtils = imageUtils ?? ImageUtils(),
        super(const PuzzleThemeState(isLoading: true)) {
    on<SplitPuzzleTheme>(_splitPuzzleTheme);

    _puzzleStateStreamSubscription = puzzleBloc.stream
        .where((event) => event.tileCount != state.splitImageList.length)
        .listen((event) => add(SplitPuzzleTheme(event.tileCount)));
  }

  final ImageUtils _imageUtils;
  late final StreamSubscription _puzzleStateStreamSubscription;

  @override
  Future<void> close() async {
    await _puzzleStateStreamSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _splitPuzzleTheme(
      SplitPuzzleTheme event, Emitter<PuzzleThemeState> emit) async {
    emit(state.copyWith(isLoading: true));
    // Could use compute() function to avoid UI freeze but not available on web.
    final imgAsByteData = await rootBundle.load(state.bgAssetImagePath),
        imgAsUInt8List = imgAsByteData.buffer.asUint8List(),
        splitImageList = _imageUtils.cutInSquares(imgAsUInt8List, event.count);
    emit(state.copyWith(splitImageList: splitImageList, isLoading: false));
  }
}
