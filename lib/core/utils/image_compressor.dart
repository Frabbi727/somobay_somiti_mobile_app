import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;

/// Shrinks payment-proof images to at most [maxBytes] before upload, so members on slow mobile
/// data send ~100 KB instead of a multi-megabyte photo. Runs in a background isolate.
class ImageCompressor {
  ImageCompressor._();

  static const maxBytes = 100 * 1024;

  /// The longest side a proof needs; a receipt screenshot stays readable at this size.
  static const _maxDimension = 1600;
  static const _qualities = [85, 75, 65, 55, 45, 35];

  /// The path of a JPEG of at most [maxBytes] (or [path] itself when already small enough);
  /// null when the file is not a readable image or cannot be brought under the limit.
  static Future<String?> compressToLimit(String path) async {
    if (File(path).lengthSync() <= maxBytes) {
      return path;
    }

    final target = '${Directory.systemTemp.path}/proof_${DateTime.now().microsecondsSinceEpoch}.jpg';
    return Isolate.run(() => _compress(path, target));
  }

  static String? _compress(String source, String target) {
    final decoded = img.decodeImage(File(source).readAsBytesSync());
    if (decoded == null) {
      return null;
    }

    var image = _fit(decoded, _maxDimension);

    // Lower the quality first, then the size, until the JPEG fits.
    while (image.width >= 200 && image.height >= 200) {
      for (final quality in _qualities) {
        final bytes = img.encodeJpg(image, quality: quality);
        if (bytes.length <= maxBytes) {
          File(target).writeAsBytesSync(bytes);
          return target;
        }
      }
      image = img.copyResize(image, width: (image.width * 0.75).round(), interpolation: img.Interpolation.average);
    }

    return null;
  }

  static img.Image _fit(img.Image image, int maxDimension) {
    final longest = image.width > image.height ? image.width : image.height;
    if (longest <= maxDimension) {
      return image;
    }
    return image.width >= image.height
        ? img.copyResize(image, width: maxDimension, interpolation: img.Interpolation.average)
        : img.copyResize(image, height: maxDimension, interpolation: img.Interpolation.average);
  }
}
