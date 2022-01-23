import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

///
/// An util class to manipulate images as [Uint8List].
/// We used it as a singleton class to facilitate mocking.
///
class ImageUtils {
  /// {@macro image_utils}
  factory ImageUtils() => _instance;

  ImageUtils._();

  static late final ImageUtils _instance = ImageUtils._();

  /// Take an [imgAsBytes] and divide it in [n] equal parts.
  List<Uint8List>? cutInSquares(List<int> imgAsBytes, int n) {
    assert(
      n > 3 && pow(sqrt(n), 2) == n,
      'n should be higher than 3 and a perfect square.',
    );

    final image = img.decodeImage(imgAsBytes);
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

  img.Image _cropImage(Rectangle<int> cropRectangle, img.Image image) {
    final image = img.Image(cropRectangle.width, cropRectangle.height),
        top = cropRectangle.top,
        left = cropRectangle.left;
    for (var y = 0; y < cropRectangle.height; y++) {
      for (var x = 0; x < cropRectangle.width; x++) {
        image.setPixel(x, y, image.getPixel(x + left, y + top));
      }
    }
    return image;
  }
}
