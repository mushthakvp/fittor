import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'svg_parser.dart';

/// A widget that renders an SVG image
class SvgImage extends StatelessWidget {
  final String? svgString;
  final String? assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AlignmentGeometry alignment;
  final Widget Function(BuildContext)? placeholderBuilder;

  /// Create an SVG image from a string
  const SvgImage({
    super.key,
    required this.svgString,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
  }) : assetName = null;

  /// Create an SVG image from an asset
  const SvgImage.asset(
    this.assetName, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
  }) : svgString = null;

  @override
  Widget build(BuildContext context) {
    if (assetName != null) {
      return FutureBuilder<String>(
        future: _loadAssetString(assetName!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return _buildSvgWidget(snapshot.data!);
          }
          if (placeholderBuilder != null) {
            return placeholderBuilder!(context);
          }
          return const SizedBox();
        },
      );
    } else if (svgString != null) {
      return _buildSvgWidget(svgString!);
    }
    return const SizedBox();
  }

  Widget _buildSvgWidget(String svgContent) {
    final svgData = SvgParser.parse(svgContent);

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: SvgPainter(svgData: svgData, color: color, fit: fit),
        size: Size(width ?? double.infinity, height ?? double.infinity),
      ),
    );
  }

  Future<String> _loadAssetString(String assetName) async {
    return await rootBundle.loadString(assetName);
  }
}

/// A simplified widget for rendering a single SVG path
class SimpleSvgImage extends StatelessWidget {
  final String svgPath;
  final double? width;
  final double? height;
  final Color color;
  final PaintingStyle style;
  final double strokeWidth;

  const SimpleSvgImage({
    super.key,
    required this.svgPath,
    this.width,
    this.height,
    this.color = Colors.black,
    this.style = PaintingStyle.fill,
    this.strokeWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: SimplePathPainter(
          pathData: svgPath,
          color: color,
          style: style,
          strokeWidth: strokeWidth,
        ),
        size: Size(width ?? double.infinity, height ?? double.infinity),
      ),
    );
  }
}

/// Painter that renders a simple SVG path
class SimplePathPainter extends CustomPainter {
  final String pathData;
  final Color color;
  final PaintingStyle style;
  final double strokeWidth;

  SimplePathPainter({
    required this.pathData,
    required this.color,
    required this.style,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = style
          ..strokeWidth = strokeWidth;

    final pathCommands = SvgPathParser.parsePathData(pathData);
    final path = SvgPathBuilder.buildPath(pathCommands);

    // Scale path to fit in the size
    final rect = path.getBounds();
    final scaleX = size.width / rect.width;
    final scaleY = size.height / rect.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final matrix =
        Matrix4.identity()
          ..translate(
            size.width / 2 - (rect.left + rect.width / 2) * scale,
            size.height / 2 - (rect.top + rect.height / 2) * scale,
          )
          ..scale(scale);

    final scaledPath = path.transform(matrix.storage);
    canvas.drawPath(scaledPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is SimplePathPainter) {
      return oldDelegate.pathData != pathData ||
          oldDelegate.color != color ||
          oldDelegate.style != style ||
          oldDelegate.strokeWidth != strokeWidth;
    }
    return true;
  }
}

/// Painter that renders a complete SVG
class SvgPainter extends CustomPainter {
  final SvgData svgData;
  final Color? color;
  final BoxFit fit;

  SvgPainter({required this.svgData, this.color, this.fit = BoxFit.contain});

  @override
  void paint(Canvas canvas, Size size) {
    if (svgData.elements.isEmpty) return;

    // Calculate scaling based on viewBox and size
    final viewBox = svgData.viewBox;
    final scaleX = size.width / viewBox.width;
    final scaleY = size.height / viewBox.height;

    double scale = 1.0;
    double translateX;
    double translateY;

    switch (fit) {
      case BoxFit.contain:
        scale = scaleX < scaleY ? scaleX : scaleY;
        translateX =
            (size.width - viewBox.width * scale) / 2 - viewBox.left * scale;
        translateY =
            (size.height - viewBox.height * scale) / 2 - viewBox.top * scale;
        break;
      case BoxFit.cover:
        scale = scaleX > scaleY ? scaleX : scaleY;
        translateX =
            (size.width - viewBox.width * scale) / 2 - viewBox.left * scale;
        translateY =
            (size.height - viewBox.height * scale) / 2 - viewBox.top * scale;
        break;
      case BoxFit.fill:
        translateX = -viewBox.left * scaleX;
        translateY = -viewBox.top * scaleY;
        canvas.scale(scaleX, scaleY);
        break;
      case BoxFit.fitWidth:
        scale = scaleX;
        translateX = -viewBox.left * scale;
        translateY =
            (size.height - viewBox.height * scale) / 2 - viewBox.top * scale;
        break;
      case BoxFit.fitHeight:
        scale = scaleY;
        translateX =
            (size.width - viewBox.width * scale) / 2 - viewBox.left * scale;
        translateY = -viewBox.top * scale;
        break;
      default:
        scale = 1.0;
        translateX = -viewBox.left;
        translateY = -viewBox.top;
    }

    canvas.save();

    if (fit != BoxFit.fill) {
      canvas.translate(translateX, translateY);
      canvas.scale(scale);
    } else {
      canvas.translate(translateX, translateY);
    }

    // Draw each SVG element
    for (final element in svgData.elements) {
      _drawElement(canvas, element);
    }

    canvas.restore();
  }

  void _drawElement(Canvas canvas, SvgElement element) {
    if (element is SvgPathElement) {
      final paint =
          Paint()
            ..style = element.style
            ..color = color ?? element.color;

      if (element.style == PaintingStyle.stroke) {
        paint.strokeWidth = element.strokeWidth;
      }

      canvas.drawPath(element.path, paint);
    } else if (element is SvgCircleElement) {
      final paint =
          Paint()
            ..style = element.style
            ..color = color ?? element.color;

      if (element.style == PaintingStyle.stroke) {
        paint.strokeWidth = element.strokeWidth;
      }

      canvas.drawCircle(element.center, element.radius, paint);
    } else if (element is SvgRectElement) {
      final paint =
          Paint()
            ..style = element.style
            ..color = color ?? element.color;

      if (element.style == PaintingStyle.stroke) {
        paint.strokeWidth = element.strokeWidth;
      }

      canvas.drawRect(element.rect, paint);
    }
    // Add more element types as needed
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is SvgPainter) {
      return oldDelegate.svgData != svgData ||
          oldDelegate.color != color ||
          oldDelegate.fit != fit;
    }
    return true;
  }
}
