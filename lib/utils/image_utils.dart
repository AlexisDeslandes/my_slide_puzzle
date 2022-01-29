import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// Result of a cut action on an image,
/// should contains the squares composing the image and the main color used
/// in this image.
class CutResult extends Equatable {
  /// {@macro image_utils}
  const CutResult({required this.squares, required this.mainColor});

  /// Squares composing the image.
  final List<Uint8List> squares;
  /// Main color used in the image.
  final Color mainColor;

  @override
  List<Object?> get props => [squares, mainColor];
}

///
/// An util class to manipulate images as [Uint8List].
/// We used it as a singleton class to facilitate mocking.
///
class ImageUtils {
  /// {@macro image_utils}
  factory ImageUtils() => _instance;

  ImageUtils._();

  static late final ImageUtils _instance = ImageUtils._();

  /// Take an [imgAsBytes] and return a [CutResult] (squares & main color).
  CutResult? cut(List<int> imgAsBytes, int n) {
    assert(
      n > 3 && pow(sqrt(n), 2) == n,
      'n should be higher than 3 and a perfect square.',
    );
    final image = img.decodeImage(imgAsBytes);
    if (image != null) {
      final mainColor = _mainColor(image),
          squares = cutInSquares(imgAsBytes, n, imageOptional: image);
      if (squares != null) {
        return CutResult(squares: squares, mainColor: mainColor);
      }
    }
  }

  /// Take an [imgAsBytes] and divide it in [n] equal parts.
  List<Uint8List>? cutInSquares(
    List<int> imgAsBytes,
    int n, {
    img.Image? imageOptional,
  }) {
    assert(
      n > 3 && pow(sqrt(n), 2) == n,
      'n should be higher than 3 and a perfect square.',
    );

    final image = imageOptional ?? img.decodeImage(imgAsBytes);
    if (image != null) {
      final squares = _splitImgInSquares(image, n),
          croppedImages = squares
              .map(
                (e) => Uint8List.fromList(img.encodePng(_cropImage(e, image))),
              )
              .toList();
      return croppedImages;
    }
  }

  List<Rectangle<int>> _splitImgInSquares(img.Image src, int n) {
    // width = height for squares
    final nSqrt = sqrt(n).toInt(), side = src.width ~/ nSqrt;
    return List.generate(
      n,
      (index) => Rectangle(
        index % nSqrt * side,
        index ~/ nSqrt * side,
        side,
        side,
      ),
    );
  }

  img.Image _cropImage(Rectangle<int> cropRectangle, img.Image originalImg) {
    final currImg = img.Image(cropRectangle.width, cropRectangle.height),
        top = cropRectangle.top,
        left = cropRectangle.left;
    for (var y = 0; y < cropRectangle.height; y++) {
      for (var x = 0; x < cropRectangle.width; x++) {
        currImg.setPixel(x, y, originalImg.getPixel(x + left, y + top));
      }
    }
    return currImg;
  }

  Color _mainColor(img.Image image) {
    final countByColor = <int, int>{};
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final color = image.getPixel(x, y);
        countByColor[color] = (countByColor[color] ?? 0) + 1;
      }
    }
    final colorAsUint32 = countByColor.entries
        .sorted((a, b) => a.value.compareTo(b.value))
        .last
        .key;
    return Color(colorAsUint32);
  }
}
