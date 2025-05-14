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

        case 'a': // arcTo (simplified implementation)
          for (int i = 0; i < params.length; i += 7) {
            if (i + 6 < params.length) {
              // For simplicity, we'll just draw a line to the end point
              // A proper arc implementation would be more complex
              final x = isRelative ? lastX + params[i + 5] : params[i + 5];
              final y = isRelative ? lastY + params[i + 6] : params[i + 6];
              path.lineTo(x, y);
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
          final style = _parsePaintingStyle(pathElement);
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
        final style = _parsePaintingStyle(circleElement);
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

        final color = _parseColor(
          rectElement.getAttribute('fill') ?? '#000000',
        );
        final style = _parsePaintingStyle(rectElement);
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

      // Add support for more SVG elements as needed

      return SvgData(viewBox: viewBox, elements: elements);
    } catch (e) {
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
  static PaintingStyle _parsePaintingStyle(xml.XmlElement element) {
    final fill = element.getAttribute('fill');
    final stroke = element.getAttribute('stroke');

    if (fill == 'none' && stroke != null && stroke != 'none') {
      return PaintingStyle.stroke;
    }

    return PaintingStyle.fill;
  }
}
