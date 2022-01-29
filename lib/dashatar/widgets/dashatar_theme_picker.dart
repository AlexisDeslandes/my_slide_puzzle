import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:very_good_slide_puzzle/audio_control/audio_control.dart';
import 'package:very_good_slide_puzzle/dashatar/dashatar.dart';
import 'package:very_good_slide_puzzle/helpers/helpers.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

/// {@template dashatar_theme_picker}
/// Displays the Dashatar theme picker to choose between
/// [DashatarThemeState.themes].
///
/// By default allows to choose between [BlueDashatarTheme],
/// [GreenDashatarTheme] or [YellowDashatarTheme].
/// {@endtemplate}
class DashatarThemePicker extends StatefulWidget {
  /// {@macro dashatar_theme_picker}
  const DashatarThemePicker({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  static const _activeThemeNormalSize = 120.0;
  static const _activeThemeSmallSize = 65.0;
  static const _inactiveThemeNormalSize = 96.0;
  static const _inactiveThemeSmallSize = 50.0;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarThemePicker> createState() => _DashatarThemePickerState();
}

class _DashatarThemePickerState extends State<DashatarThemePicker> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<DashatarThemeBloc>().state;
    final activeTheme = themeState.theme;

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          final isSmallSize = currentSize == ResponsiveLayoutSize.small;
          final activeSize = isSmallSize
              ? DashatarThemePicker._activeThemeSmallSize
              : DashatarThemePicker._activeThemeNormalSize;
          final inactiveSize = isSmallSize
              ? DashatarThemePicker._inactiveThemeSmallSize
              : DashatarThemePicker._inactiveThemeNormalSize;

          return SizedBox(
            key: const Key('dashatar_theme_picker'),
            height: activeSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  themeState.themes.length,
                  (index) {
                    final theme = themeState.themes[index];
                    final isActiveTheme = theme == activeTheme;
                    final padding = index > 0 ? (isSmallSize ? 4.0 : 8.0) : 0.0;
                    final size = isActiveTheme ? activeSize : inactiveSize;

                    return Padding(
                      padding: EdgeInsets.only(left: padding),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          key: Key('dashatar_theme_picker_$index'),
                          onTap: () async {
                            if (isActiveTheme) {
                              return;
                            }

                            // Update the current Dashatar theme.
                            context
                                .read<DashatarThemeBloc>()
                                .add(DashatarThemeChanged(themeIndex: index));

                            // Play the audio of the current Dashatar theme.
                            await _audioPlayer.setAsset(theme.audioAsset);
                            unawaited(_audioPlayer.play());
                          },
                          child: AnimatedContainer(
                            width: size,
                            height: size,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 350),
                            child: theme.themeImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      theme.themeImage!,
                                      fit: BoxFit.fill,
                                      semanticLabel:
                                          theme.semanticsLabel(context),
                                    ),
                                  )
                                : Image.asset(
                                    theme.themeAsset,
                                    fit: BoxFit.fill,
                                    semanticLabel:
                                        theme.semanticsLabel(context),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AddDashatarThemeButtonAnimated(
                    color: themeState.theme.buttonColor,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddDashatarThemeButtonAnimated extends ImplicitlyAnimatedWidget {
  const AddDashatarThemeButtonAnimated({Key? key, required this.color})
      : super(
            key: key,
            duration: PuzzleThemeAnimationDuration.textStyle,
            curve: Curves.linear);

  final Color color;

  @override
  _AddDashatarThemeButtonAnimatedState createState() =>
      _AddDashatarThemeButtonAnimatedState();
}

class _AddDashatarThemeButtonAnimatedState
    extends AnimatedWidgetBaseState<AddDashatarThemeButtonAnimated> {
  ColorTween? _colorTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<DashatarThemeBloc>().state,
        activeTheme = themeState.theme;
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final isSmallSize = currentSize == ResponsiveLayoutSize.small,
            inactiveSize = isSmallSize
                ? DashatarThemePicker._inactiveThemeSmallSize
                : DashatarThemePicker._inactiveThemeNormalSize;
        return Material(
          color: _colorTween!.evaluate(animation),
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () =>
                context.read<DashatarThemeBloc>().add(const AddDashatarTheme()),
            child: SizedBox(
              width: inactiveSize,
              height: inactiveSize,
              child: Icon(
                Icons.add,
                color: activeTheme.titleColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
