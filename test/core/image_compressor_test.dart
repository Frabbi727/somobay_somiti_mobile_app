import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:somobay_somiti_mobile_app/core/utils/image_compressor.dart';

/// A photo-sized image full of noise: the hardest case for JPEG.
File noisyPng(Directory dir, int width, int height) {
  final random = Random(7);
  final image = img.Image(width: width, height: height);
  for (final pixel in image) {
    pixel
      ..r = random.nextInt(256)
      ..g = random.nextInt(256)
      ..b = random.nextInt(256);
  }
  return File('${dir.path}/photo.png')..writeAsBytesSync(img.encodePng(image));
}

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('compress_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('compresses a large photo to a JPEG of at most 100 KB', () async {
    final source = noisyPng(dir, 3000, 2000);
    expect(source.lengthSync(), greaterThan(ImageCompressor.maxBytes));

    final result = await ImageCompressor.compressToLimit(source.path);

    expect(result, isNotNull);
    final out = File(result!);
    expect(out.lengthSync(), lessThanOrEqualTo(ImageCompressor.maxBytes));
    expect(out.path, endsWith('.jpg'));
    expect(img.decodeJpg(out.readAsBytesSync()), isNotNull);
  });

  test('keeps an image that is already small enough', () async {
    final small = File('${dir.path}/small.jpg')..writeAsBytesSync(img.encodeJpg(img.Image(width: 200, height: 200)));

    expect(await ImageCompressor.compressToLimit(small.path), small.path);
  });

  test('returns null for a large file that is not an image', () async {
    final notImage = File('${dir.path}/x.jpg')..writeAsStringSync('not an image' * 20000);

    expect(await ImageCompressor.compressToLimit(notImage.path), isNull);
  });
}
