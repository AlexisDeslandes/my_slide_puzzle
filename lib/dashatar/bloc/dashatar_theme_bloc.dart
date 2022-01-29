import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/dashatar/dashatar.dart';
import 'package:very_good_slide_puzzle/dashatar/themes/dynamic_dashatar_theme.dart';
import 'package:very_good_slide_puzzle/utils/image_utils.dart';

part 'dashatar_theme_event.dart';

part 'dashatar_theme_state.dart';

/// {@template dashatar_theme_bloc}
/// Bloc responsible for the currently selected [DashatarTheme].
/// {@endtemplate}
class DashatarThemeBloc extends Bloc<DashatarThemeEvent, DashatarThemeState> {
  /// {@macro dashatar_theme_bloc}
  DashatarThemeBloc({
    required List<DashatarTheme> themes,
    FilePicker? filePicker,
    ImageUtils? imageUtils,
  })  : _filePicker = filePicker ?? FilePicker.platform,
        _imageUtils = imageUtils ?? ImageUtils(),
        super(DashatarThemeState(themes: themes)) {
    on<DashatarThemeChanged>(_onDashatarThemeChanged);
    on<AddDashatarTheme>(_addDashatarTheme);
  }

  final FilePicker _filePicker;
  final ImageUtils _imageUtils;

  void _onDashatarThemeChanged(
    DashatarThemeChanged event,
    Emitter<DashatarThemeState> emit,
  ) {
    emit(state.copyWith(theme: state.themes[event.themeIndex]));
  }

  FutureOr<void> _addDashatarTheme(
      AddDashatarTheme event, Emitter<DashatarThemeState> emit) async {
    final result = await _filePicker.pickFiles();
    if (result != null) {
      final bytes = result.files.first.bytes;
      if (bytes != null) {
        final cutResult = _imageUtils.cut(bytes, 16);
        if (cutResult != null) {
          final mainColor = cutResult.mainColor,
              theme = DynamicDashatarTheme(
                  backgroundColor: mainColor.darken(),
                  defaultColor: mainColor.darken(0.2),
                  btnColor: mainColor.darken(0.3),
                  themeImage: bytes,
                  splitThemeImage: cutResult.squares);
          emit(state.copyWith(theme: theme, themes: [...state.themes, theme]));
        }
      }
    }
  }
}
