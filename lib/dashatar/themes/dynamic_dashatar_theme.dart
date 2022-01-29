import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/dashatar/dashatar.dart';

/// {@template dynamic_dashatar_theme}
/// The dynamic dashatar puzzle theme.
/// {@endtemplate}
class DynamicDashatarTheme extends DashatarTheme {
  /// {@macro dynamic_dashatar_theme}
  const DynamicDashatarTheme({
    this.backgroundColor = const Color(0xFF181919),
    required this.defaultColor,
    required Color btnColor,
    required this.themeImage,
    required this.splitThemeImage,
  })  : buttonColor = btnColor,
        menuInactiveColor = btnColor,
        countdownColor = btnColor,
        super();

  @override
  final Uint8List themeImage;

  @override
  final List<Uint8List> splitThemeImage;

  @override
  final Color backgroundColor;

  @override
  final Color defaultColor;

  @override
  final Color buttonColor;

  @override
  final Color menuInactiveColor;

  @override
  final Color countdownColor;

  @override
  String semanticsLabel(BuildContext context) => 'Dynamic dash';

  @override
  String get themeAsset => '';

  @override
  String get successThemeAsset => '';

  @override
  String get dashAssetsDirectory => '';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/green_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/skateboard.mp3';
}
