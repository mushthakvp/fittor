import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

/// Represents an SVG viewbox
class SvgViewBox {
  final double left;
  final double top;
  final double width;
  final double height;

  const SvgViewBox({
    this.left = 0.0,
    this.top = 0.0,
    required this.width,
    required this.height,
  });

  factory SvgViewBox.fromString(String? viewBox) {
    if (viewBox == null || viewBox.isEmpty) {
      return const SvgViewBox(width: 24, height: 24);
    }

    final parts = viewBox.trim().split(RegExp(r'[\s,]+'));
    if (parts.length == 4) {
      return SvgViewBox(
        left: double.tryParse(parts[0]) ?? 0.0,
        top: double.tryParse(parts[1]) ?? 0.0,
        width: double.tryParse(parts[2]) ?? 24.0,
        height: double.tryParse(parts[3]) ?? 24.0,
      );
    }
    return const SvgViewBox(width: 24, height: 24);
  }
}

/// Base class for SVG elements
abstract class SvgElement {
  final Color color;
  final PaintingStyle style;
  final double strokeWidth;

  SvgElement({
    required this.color,
    required this.style,
    required this.strokeWidth,
  });
}

/// SVG Path element
class SvgPathElement extends SvgElement {
  final Path path;

  SvgPathElement({
    required this.path,
    required super.color,
    required super.style,
    required super.strokeWidth,
  });
}

/// SVG Circle element
class SvgCircleElement extends SvgElement {
  final Offset center;
  final double radius;

  SvgCircleElement({
    required this.center,
    required this.radius,
    required super.color,
    required super.style,
    required super.strokeWidth,
  });
}

/// SVG Rectangle element
class SvgRectElement extends SvgElement {
  final Rect rect;
  final double rx;
  final double ry;

  SvgRectElement({
    required this.rect,
    this.rx = 0.0,
    this.ry = 0.0,
    required super.color,
    required super.style,
    required super.strokeWidth,
  });
}

/// Complete SVG data including viewBox and elements
class SvgData {
  final SvgViewBox viewBox;
  final List<SvgElement> elements;

  SvgData({required this.viewBox, required this.elements});
}

/// Command for SVG path
class PathCommand {
  final String command;
  final List<double> parameters;

  PathCommand(this.command, this.parameters);
}

/// Parser for SVG path commands
class SvgPathParser {
  /// Parse SVG path data string into a list of path commands
  static List<PathCommand> parsePathData(String pathData) {
    final List<PathCommand> commands = [];
    final RegExp commandRegex = RegExp(
      r'([a-zA-Z])|([-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?)',
    );

    String? currentCommand;
    List<double> parameters = [];

    for (final match in commandRegex.allMatches(pathData)) {
      final String? cmdStr = match.group(1);
      final String? paramStr = match.group(2);

      if (cmdStr != null) {
        // Save the previous command
        if (currentCommand != null && parameters.isNotEmpty) {
          commands.add(PathCommand(currentCommand, List.from(parameters)));
          parameters.clear();
        }
        currentCommand = cmdStr;
      } else if (paramStr != null && currentCommand != null) {
        parameters.add(double.parse(paramStr));
      }
    }

    // Add the last command
    if (currentCommand != null && parameters.isNotEmpty) {
      commands.add(PathCommand(currentCommand, List.from(parameters)));
    }

    return commands;
  }
}

/// Builder for creating Flutter Path objects from SVG path commands
class SvgPathBuilder {
  /// Build Flutter Path from a list of path commands
  static Path buildPath(List<PathCommand> commands) {
    final path = Path();
    double lastX = 0;
    double lastY = 0;
    double lastControlX = 0;
    double lastControlY = 0;
    bool hasCurrentPoint = false;

    for (final cmd in commands) {
      final params = cmd.parameters;
      final command = cmd.command;
      final isRelative = command.toLowerCase() == command;

      switch (command.toLowerCase()) {
        case 'm': // moveTo
          for (int i = 0; i < params.length; i += 2) {
            if (i + 1 < params.length) {
              final x = isRelative ? lastX + params[i] : params[i];
              final y = isRelative ? lastY + params[i + 1] : params[i + 1];

              if (i == 0) {
                path.moveTo(x, y);
              } else {
                path.lineTo(x, y);
              }

              lastX = x;
              lastY = y;
              hasCurrentPoint = true;
            }
          }
          break;

        case 'l': // lineTo
          for (int i = 0; i < params.length; i += 2) {
            if (i + 1 < params.length) {
              final x = isRelative ? lastX + params[i] : params[i];
              final y = isRelative ? lastY + params[i + 1] : params[i + 1];
              path.lineTo(x, y);
              lastX = x;
              lastY = y;
            }
          }
          break;

        case 'h': // horizontal lineTo
          for (final param in params) {
            final x = isRelative ? lastX + param : param;
            path.lineTo(x, lastY);
            lastX = x;
          }
          break;

        case 'v': // vertical lineTo
          for (final param in params) {
            final y = isRelative ? lastY + param : param;
            path.lineTo(lastX, y);
            lastY = y;
          }
          break;

        case 'c': // cubicTo
          for (int i = 0; i < params.length; i += 6) {
            if (i + 5 < params.length) {
              final x1 = isRelative ? lastX + params[i] : params[i];
              final y1 = isRelative ? lastY + params[i + 1] : params[i + 1];
              final x2 = isRelative ? lastX + params[i + 2] : params[i + 2];
              final y2 = isRelative ? lastY + params[i + 3] : params[i + 3];
              final x = isRelative ? lastX + params[i + 4] : params[i + 4];
              final y = isRelative ? lastY + params[i + 5] : params[i + 5];

              path.cubicTo(x1, y1, x2, y2, x, y);

              lastControlX = x2;
              lastControlY = y2;
              lastX = x;
              lastY = y;
            }
          }
          break;

        case 's': // smooth cubicTo
          for (int i = 0; i < params.length; i += 4) {
            if (i + 3 < params.length) {
              // Reflect the last control point
              double x1 = lastX;
              double y1 = lastY;

              if (hasCurrentPoint) {
                x1 = 2 * lastX - lastControlX;
                y1 = 2 * lastY - lastControlY;
              }

              final x2 = isRelative ? lastX + params[i] : params[i];
              final y2 = isRelative ? lastY + params[i + 1] : params[i + 1];
              final x = isRelative ? lastX + params[i + 2] : params[i + 2];
              final y = isRelative ? lastY + params[i + 3] : params[i + 3];

              path.cubicTo(x1, y1, x2, y2, x, y);

              lastControlX = x2;
              lastControlY = y2;
              lastX = x;
              lastY = y;
            }
          }
          break;

        case 'q': // quadraticBezierTo
          for (int i = 0; i < params.length; i += 4) {
            if (i + 3 < params.length) {
              final x1 = isRelative ? lastX + params[i] : params[i];
              final y1 = isRelative ? lastY + params[i + 1] : params[i + 1];
              final x = isRelative ? lastX + params[i + 2] : params[i + 2];
              final y = isRelative ? lastY + params[i + 3] : params[i + 3];

              path.quadraticBezierTo(x1, y1, x, y);

              lastControlX = x1;
              lastControlY = y1;
              lastX = x;
              lastY = y;
            }
          }
          break;

        case 't': // smooth quadraticBezierTo
          for (int i = 0; i < params.length; i += 2) {
            if (i + 1 < params.length) {
              // Reflect the last control point
              double x1 = lastX;
              double y1 = lastY;

              if (hasCurrentPoint) {
                x1 = 2 * lastX - lastControlX;
                y1 = 2 * lastY - lastControlY;
              }

              final x = isRelative ? lastX + params[i] : params[i];
              final y = isRelative ? lastY + params[i + 1] : params[i + 1];

              path.quadraticBezierTo(x1, y1, x, y);

              lastControlX = x1;
              lastControlY = y1;
              lastX = x;
              lastY = y;
            }
          }
          break;

        case 'a': // arcTo - Improved implementation
          for (int i = 0; i < params.length; i += 7) {
            if (i + 6 < params.length) {
              final rx = params[i].abs();
              final ry = params[i + 1].abs();
              final xAxisRotation = params[i + 2] * math.pi / 180;
              final largeArcFlag = params[i + 3] != 0;
              final sweepFlag = params[i + 4] != 0;
              final x = isRelative ? lastX + params[i + 5] : params[i + 5];
              final y = isRelative ? lastY + params[i + 6] : params[i + 6];

              _addArcToPath(
                path,
                lastX,
                lastY,
                rx,
                ry,
                xAxisRotation,
                largeArcFlag,
                sweepFlag,
                x,
                y,
              );

              lastX = x;
              lastY = y;
            }
          }
          break;

        case 'z': // closePath
          path.close();
          break;
      }
    }

    return path;
  }

  /// Add an elliptical arc to the path
  static void _addArcToPath(
    Path path,
    double lastX,
    double lastY,
    double rx,
    double ry,
    double xAxisRotation,
    bool largeArcFlag,
    bool sweepFlag,
    double x,
    double y,
  ) {
    // If radii are 0, just draw a line
    if (rx == 0 || ry == 0) {
      path.lineTo(x, y);
      return;
    }

    // If endpoints are the same, do nothing
    if (lastX == x && lastY == y) {
      return;
    }

    // Convert the arc to cubic bezier curves
    _arcToCubicBeziers(
      path,
      lastX,
      lastY,
      rx,
      ry,
      xAxisRotation,
      largeArcFlag,
      sweepFlag,
      x,
      y,
    );
  }

  /// Convert an elliptical arc to a series of cubic bezier curves
  static void _arcToCubicBeziers(
    Path path,
    double x1,
    double y1,
    double rx,
    double ry,
    double xAxisRotation,
    bool largeArcFlag,
    bool sweepFlag,
    double x2,
    double y2,
  ) {
    // Step 1: Compute the center of the ellipse
    final cosAngle = math.cos(xAxisRotation);
    final sinAngle = math.sin(xAxisRotation);

    // Step 1.1: Transform to standard position
    final dx = (x1 - x2) / 2;
    final dy = (y1 - y2) / 2;
    final x1p = cosAngle * dx + sinAngle * dy;
    final y1p = -sinAngle * dx + cosAngle * dy;

    // Ensure radii are large enough
    rx = rx.abs();
    ry = ry.abs();
    double rxSq = rx * rx;
    double rySq = ry * ry;
    final x1pSq = x1p * x1p;
    final y1pSq = y1p * y1p;

    // Check if radii are big enough
    double radiiCheck = x1pSq / rxSq + y1pSq / rySq;
    if (radiiCheck > 1) {
      rx *= math.sqrt(radiiCheck);
      ry *= math.sqrt(radiiCheck);
      rxSq = rx * rx;
      rySq = ry * ry;
    }

    // Step 1.2: Compute center parameters
    double sign = (largeArcFlag == sweepFlag) ? -1 : 1;
    double sq =
        ((rxSq * rySq) - (rxSq * y1pSq) - (rySq * x1pSq)) /
        ((rxSq * y1pSq) + (rySq * x1pSq));
    sq = sq < 0 ? 0 : sq;
    final coef = sign * math.sqrt(sq);
    final cxp = coef * ((rx * y1p) / ry);
    final cyp = coef * -((ry * x1p) / rx);

    // Step 1.3: Transform back
    final cx = cosAngle * cxp - sinAngle * cyp + (x1 + x2) / 2;
    final cy = sinAngle * cxp + cosAngle * cyp + (y1 + y2) / 2;

    // Step 2: Compute the start and end angles
    final ux = (x1p - cxp) / rx;
    final uy = (y1p - cyp) / ry;
    final vx = (-x1p - cxp) / rx;
    final vy = (-y1p - cyp) / ry;

    // Initial angle
    double startAngle = _angle(1, 0, ux, uy);

    // Sweep angle
    double sweepAngle = _angle(ux, uy, vx, vy);
    if (!sweepFlag && sweepAngle > 0) {
      sweepAngle -= 2 * math.pi;
    } else if (sweepFlag && sweepAngle < 0) {
      sweepAngle += 2 * math.pi;
    }

    // Approximate the arc using cubic bezier curves
    final numSegments = math.max(1, (sweepAngle.abs() * 2 / math.pi).ceil());
    final angleDelta = sweepAngle / numSegments;

    // Draw the segments
    for (int i = 0; i < numSegments; i++) {
      _approximateArcSegment(
        path,
        cx,
        cy,
        rx,
        ry,
        startAngle + i * angleDelta,
        angleDelta,
        xAxisRotation,
      );
    }
  }

  /// Calculate the angle between two vectors
  static double _angle(double ux, double uy, double vx, double vy) {
    final dot = ux * vx + uy * vy;
    final len = math.sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy));
    double angle = math.acos(dot / len);

    // Determine the sign
    if (ux * vy - uy * vx < 0) {
      angle = -angle;
    }

    return angle;
  }

  /// Approximate an elliptical arc segment using a cubic bezier curve
  static void _approximateArcSegment(
    Path path,
    double cx,
    double cy,
    double rx,
    double ry,
    double startAngle,
    double sweepAngle,
    double rotationAngle,
  ) {
    final cosRotation = math.cos(rotationAngle);
    final sinRotation = math.sin(rotationAngle);
    final endAngle = startAngle + sweepAngle;

    // Calculate the start and end points
    final startX =
        cx +
        rx * math.cos(startAngle) * cosRotation -
        ry * math.sin(startAngle) * sinRotation;
    final startY =
        cy +
        rx * math.cos(startAngle) * sinRotation +
        ry * math.sin(startAngle) * cosRotation;
    final endX =
        cx +
        rx * math.cos(endAngle) * cosRotation -
        ry * math.sin(endAngle) * sinRotation;
    final endY =
        cy +
        rx * math.cos(endAngle) * sinRotation +
        ry * math.sin(endAngle) * cosRotation;

    // Calculate the control points using the approximation formula
    // For an arc segment, the approximation factor is 4/3 * tan(sweepAngle/4)
    final alpha = math.tan(sweepAngle / 4) * 4 / 3;

    // First control point
    final cp1x =
        startX -
        alpha * rx * math.sin(startAngle) * cosRotation -
        alpha * ry * math.cos(startAngle) * sinRotation;
    final cp1y =
        startY -
        alpha * rx * math.sin(startAngle) * sinRotation +
        alpha * ry * math.cos(startAngle) * cosRotation;

    // Second control point
    final cp2x =
        endX +
        alpha * rx * math.sin(endAngle) * cosRotation +
        alpha * ry * math.cos(endAngle) * sinRotation;
    final cp2y =
        endY +
        alpha * rx * math.sin(endAngle) * sinRotation -
        alpha * ry * math.cos(endAngle) * cosRotation;

    // Add the cubic bezier curve
    path.cubicTo(cp1x, cp1y, cp2x, cp2y, endX, endY);
  }
}

/// Main parser for SVG content
class SvgParser {
  /// Parse SVG string content to SvgData
  static SvgData parse(String svgString) {
    try {
      final document = xml.XmlDocument.parse(svgString);
      final svgElement = document.findElements('svg').first;

      // Parse the viewBox
      final viewBoxAttr = svgElement.getAttribute('viewBox');
      final viewBox = SvgViewBox.fromString(viewBoxAttr);

      // Parse SVG elements
      final elements = <SvgElement>[];

      // Process paths
      for (final pathElement in svgElement.findElements('path')) {
        final pathData = pathElement.getAttribute('d');
        if (pathData != null) {
          final pathCommands = SvgPathParser.parsePathData(pathData);
          final path = SvgPathBuilder.buildPath(pathCommands);

          // Parse style attributes
          final color = _parseColor(
            pathElement.getAttribute('fill') ?? '#000000',
          );
          final style = parsePaintingStyle(pathElement);
          final strokeWidth =
              double.tryParse(
                pathElement.getAttribute('stroke-width') ?? '1.0',
              ) ??
              1.0;

          elements.add(
            SvgPathElement(
              path: path,
              color: color,
              style: style,
              strokeWidth: strokeWidth,
            ),
          );
        }
      }

      // Process circles
      for (final circleElement in svgElement.findElements('circle')) {
        final cx =
            double.tryParse(circleElement.getAttribute('cx') ?? '0') ?? 0.0;
        final cy =
            double.tryParse(circleElement.getAttribute('cy') ?? '0') ?? 0.0;
        final r =
            double.tryParse(circleElement.getAttribute('r') ?? '0') ?? 0.0;

        final color = _parseColor(
          circleElement.getAttribute('fill') ?? '#000000',
        );
        final style = parsePaintingStyle(circleElement);
        final strokeWidth =
            double.tryParse(
              circleElement.getAttribute('stroke-width') ?? '1.0',
            ) ??
            1.0;

        elements.add(
          SvgCircleElement(
            center: Offset(cx, cy),
            radius: r,
            color: color,
            style: style,
            strokeWidth: strokeWidth,
          ),
        );
      }

      // Process ellipses - Added support for ellipse elements
      for (final ellipseElement in svgElement.findElements('ellipse')) {
        final cx =
            double.tryParse(ellipseElement.getAttribute('cx') ?? '0') ?? 0.0;
        final cy =
            double.tryParse(ellipseElement.getAttribute('cy') ?? '0') ?? 0.0;
        final rx =
            double.tryParse(ellipseElement.getAttribute('rx') ?? '0') ?? 0.0;
        final ry =
            double.tryParse(ellipseElement.getAttribute('ry') ?? '0') ?? 0.0;

        // Create a path for the ellipse
        final path = Path();
        // Ellipse using 4 Bezier curves
        path.moveTo(cx + rx, cy);
        path.cubicTo(
          cx + rx,
          cy + ry * 0.552,
          cx + rx * 0.552,
          cy + ry,
          cx,
          cy + ry,
        );
        path.cubicTo(
          cx - rx * 0.552,
          cy + ry,
          cx - rx,
          cy + ry * 0.552,
          cx - rx,
          cy,
        );
        path.cubicTo(
          cx - rx,
          cy - ry * 0.552,
          cx - rx * 0.552,
          cy - ry,
          cx,
          cy - ry,
        );
        path.cubicTo(
          cx + rx * 0.552,
          cy - ry,
          cx + rx,
          cy - ry * 0.552,
          cx + rx,
          cy,
        );
        path.close();

        final color = _parseColor(
          ellipseElement.getAttribute('fill') ?? '#000000',
        );
        final style = parsePaintingStyle(ellipseElement);
        final strokeWidth =
            double.tryParse(
              ellipseElement.getAttribute('stroke-width') ?? '1.0',
            ) ??
            1.0;

        elements.add(
          SvgPathElement(
            path: path,
            color: color,
            style: style,
            strokeWidth: strokeWidth,
          ),
        );
      }

      // Process rectangles
      for (final rectElement in svgElement.findElements('rect')) {
        final x = double.tryParse(rectElement.getAttribute('x') ?? '0') ?? 0.0;
        final y = double.tryParse(rectElement.getAttribute('y') ?? '0') ?? 0.0;
        final width =
            double.tryParse(rectElement.getAttribute('width') ?? '0') ?? 0.0;
        final height =
            double.tryParse(rectElement.getAttribute('height') ?? '0') ?? 0.0;
        final rx =
            double.tryParse(rectElement.getAttribute('rx') ?? '0') ?? 0.0;
        final ry =
            double.tryParse(rectElement.getAttribute('ry') ?? '0') ?? 0.0;

        // For rounded rectangles, create a custom path
        if (rx > 0 || ry > 0) {
          final effectiveRx = rx > 0 ? rx : ry;
          final effectiveRy = ry > 0 ? ry : rx;

          // Create a path with rounded corners
          final path = Path();
          path.moveTo(x + effectiveRx, y);
          path.lineTo(x + width - effectiveRx, y);
          path.cubicTo(
            x + width - effectiveRx / 2,
            y,
            x + width,
            y + effectiveRy / 2,
            x + width,
            y + effectiveRy,
          );
          path.lineTo(x + width, y + height - effectiveRy);
          path.cubicTo(
            x + width,
            y + height - effectiveRy / 2,
            x + width - effectiveRx / 2,
            y + height,
            x + width - effectiveRx,
            y + height,
          );
          path.lineTo(x + effectiveRx, y + height);
          path.cubicTo(
            x + effectiveRx / 2,
            y + height,
            x,
            y + height - effectiveRy / 2,
            x,
            y + height - effectiveRy,
          );
          path.lineTo(x, y + effectiveRy);
          path.cubicTo(
            x,
            y + effectiveRy / 2,
            x + effectiveRx / 2,
            y,
            x + effectiveRx,
            y,
          );
          path.close();

          final color = _parseColor(
            rectElement.getAttribute('fill') ?? '#000000',
          );
          final style = parsePaintingStyle(rectElement);
          final strokeWidth =
              double.tryParse(
                rectElement.getAttribute('stroke-width') ?? '1.0',
              ) ??
              1.0;

          elements.add(
            SvgPathElement(
              path: path,
              color: color,
              style: style,
              strokeWidth: strokeWidth,
            ),
          );
        } else {
          // Regular rectangle without rounded corners
          final color = _parseColor(
            rectElement.getAttribute('fill') ?? '#000000',
          );
          final style = parsePaintingStyle(rectElement);
          final strokeWidth =
              double.tryParse(
                rectElement.getAttribute('stroke-width') ?? '1.0',
              ) ??
              1.0;

          elements.add(
            SvgRectElement(
              rect: Rect.fromLTWH(x, y, width, height),
              rx: rx,
              ry: ry,
              color: color,
              style: style,
              strokeWidth: strokeWidth,
            ),
          );
        }
      }

      // Process polygons and polylines
      for (final polygonElement in [
        ...svgElement.findElements('polygon'),
        ...svgElement.findElements('polyline'),
      ]) {
        final isPolygon = polygonElement.name.local == 'polygon';
        final pointsStr = polygonElement.getAttribute('points');

        if (pointsStr != null && pointsStr.isNotEmpty) {
          final points = <Offset>[];
          final coords = pointsStr.trim().split(RegExp(r'[\s,]+'));

          for (int i = 0; i < coords.length - 1; i += 2) {
            if (i + 1 < coords.length) {
              final x = double.tryParse(coords[i]);
              final y = double.tryParse(coords[i + 1]);
              if (x != null && y != null) {
                points.add(Offset(x, y));
              }
            }
          }

          if (points.isNotEmpty) {
            final path = Path();
            path.moveTo(points[0].dx, points[0].dy);

            for (int i = 1; i < points.length; i++) {
              path.lineTo(points[i].dx, points[i].dy);
            }

            if (isPolygon) {
              path.close();
            }

            final color = _parseColor(
              polygonElement.getAttribute('fill') ?? '#000000',
            );
            final style = parsePaintingStyle(polygonElement);
            final strokeWidth =
                double.tryParse(
                  polygonElement.getAttribute('stroke-width') ?? '1.0',
                ) ??
                1.0;

            elements.add(
              SvgPathElement(
                path: path,
                color: color,
                style: style,
                strokeWidth: strokeWidth,
              ),
            );
          }
        }
      }

      // Add support for more SVG elements as needed

      return SvgData(viewBox: viewBox, elements: elements);
    } catch (e) {
      debugPrint('SVG Parsing Error: $e');
      // Return empty SVG data on error
      return SvgData(
        viewBox: const SvgViewBox(width: 24, height: 24),
        elements: [],
      );
    }
  }

  /// Parse color from SVG attribute
  static Color _parseColor(String colorString) {
    if (colorString == 'none' || colorString.isEmpty) {
      return Colors.transparent;
    }

    // Handle hex colors
    if (colorString.startsWith('#')) {
      String hex = colorString.substring(1);
      if (hex.length == 3) {
        // Convert shorthand format to full format
        hex = hex.split('').map((c) => '$c$c').join('');
      }

      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    /// Parse color from SVG attribute

    if (colorString == 'none' || colorString.isEmpty) {
      return Colors.transparent;
    }

    // Handle hex colors
    if (colorString.startsWith('#')) {
      String hex = colorString.substring(1);
      if (hex.length == 3) {
        // Convert shorthand format to full format
        hex = hex.split('').map((c) => '$c$c').join('');
      }

      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    // Handle named colors
    switch (colorString.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      // Add more named colors as needed
      default:
        return Colors.black;
    }
  }

  /// Parse painting style from SVG element
  static PaintingStyle parsePaintingStyle(xml.XmlElement element) {
    final fill = element.getAttribute('fill');
    final stroke = element.getAttribute('stroke');

    if (fill == 'none' && stroke != null && stroke != 'none') {
      return PaintingStyle.stroke;
    }

    return PaintingStyle.fill;
  }
}
