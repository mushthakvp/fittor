import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BlurHashDecoder {
  static const String _base83 =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#\$%*+,-.:;=?@[]^_{|}~';

  static int _decode83(String str) {
    int value = 0;
    for (int i = 0; i < str.length; i++) {
      final index = _base83.indexOf(str[i]);
      if (index == -1) throw Exception('Invalid character in blurhash');
      value = value * 83 + index;
    }
    return value;
  }

  static double _sRGBToLinear(int value) {
    final v = value / 255;
    if (v <= 0.04045) return v / 12.92;
    return pow((v + 0.055) / 1.055, 2.4).toDouble();
  }

  static int _linearToSRGB(double value) {
    final v = max(0, min(1, value));
    if (v <= 0.0031308) return (v * 12.92 * 255 + 0.5).floor();
    return ((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5).floor();
  }

  static List<double> _decodeDC(int value) {
    final r = value >> 16;
    final g = (value >> 8) & 255;
    final b = value & 255;
    return [
      _sRGBToLinear(r),
      _sRGBToLinear(g),
      _sRGBToLinear(b),
    ];
  }

  static List<double> _decodeAC(int value, double maximumValue) {
    final quantR = (value / (19 * 19)).floor();
    final quantG = ((value / 19).floor()) % 19;
    final quantB = value % 19;

    return [
      _signPow((quantR - 9) / 9.0, 2.0) * maximumValue,
      _signPow((quantG - 9) / 9.0, 2.0) * maximumValue,
      _signPow((quantB - 9) / 9.0, 2.0) * maximumValue,
    ];
  }

  static double _signPow(double val, double exp) {
    return pow(val.abs(), exp).toDouble() * (val < 0 ? -1 : 1);
  }

  static Future<ImageProvider> decodeToImage(
      String blurHash, int width, int height,
      {double punch = 1.0}) async {
    if (blurHash.length < 6) throw Exception("BlurHash too short");

    final sizeFlag = _decode83(blurHash[0]);
    final numY = (sizeFlag / 9).floor() + 1;
    final numX = (sizeFlag % 9) + 1;

    final quantMaxValue = _decode83(blurHash[1]);
    final maxValue = (quantMaxValue + 1) / 166.0;

    final colors = <List<double>>[];

    int index = 2;
    final dcValue = _decode83(blurHash.substring(index, index + 4));
    index += 4;
    colors.add(_decodeDC(dcValue));

    for (int i = 1; i < numX * numY; i++) {
      final acValue = _decode83(blurHash.substring(index, index + 2));
      index += 2;
      colors.add(_decodeAC(acValue, maxValue * punch));
    }

    final pixels = Uint8List(width * height * 4);
    int byteIndex = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double r = 0, g = 0, b = 0;

        for (int j = 0; j < numY; j++) {
          for (int i = 0; i < numX; i++) {
            final basis = cos(pi * x * i / width) * cos(pi * y * j / height);
            final color = colors[i + j * numX];
            r += color[0] * basis;
            g += color[1] * basis;
            b += color[2] * basis;
          }
        }

        final ir = _linearToSRGB(r);
        final ig = _linearToSRGB(g);
        final ib = _linearToSRGB(b);

        pixels[byteIndex++] = ir;
        pixels[byteIndex++] = ig;
        pixels[byteIndex++] = ib;
        pixels[byteIndex++] = 255;
      }
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (img) => completer.complete(img),
    );

    final ui.Image img = await completer.future;
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return MemoryImage(byteData!.buffer.asUint8List());
  }
}
