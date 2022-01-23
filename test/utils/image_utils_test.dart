import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_slide_puzzle/utils/utils.dart';

import 'images/color_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ImageUtils', () {
    final utils = ImageUtils();

    group('cutInSquares', () {
      test('Should throw assertion error with numbers < 4 & no square perfect.',
          () {
        expect(() => utils.cutInSquares(Uint8List(0), 3), throwsAssertionError);
        expect(() => utils.cutInSquares(Uint8List(0), 8), throwsAssertionError);
        expect(
            () => utils.cutInSquares(Uint8List(0), 15), throwsAssertionError);
      });

      test(
          'Given a 2*2 image, cutInSquares(4) should return '
          '4 squares as Uint8List [blue,orange,red,green].', () async {
        final imgAsByteData = File('test/utils/images/2*2.png'),
            imgAsUInt8List = imgAsByteData.readAsBytesSync(),
            squares = utils.cutInSquares(imgAsUInt8List, 4);
        expect(squares, [blue, orange, red, green]);
      });

      test(
          'Given a 4*4 image, cutInSquares(4) should return '
          '4 squares as Uint8List [blue,orange,red,green].', () async {
        final imgAsByteData = File('test/utils/images/4*4.png'),
            imgAsUInt8List = imgAsByteData.readAsBytesSync(),
            squares = utils.cutInSquares(imgAsUInt8List, 4);
        expect(squares, [topLeft, topRight, btmLeft, btmRight]);
      });
    });
  });
}
