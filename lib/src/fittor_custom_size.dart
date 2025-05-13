import 'package:flutter/widgets.dart';

extension SizeExtension on num {
  Widget get w => SizedBox(width: toDouble());

  Widget get h => SizedBox(height: toDouble());

  Widget get s => SizedBox.square(dimension: toDouble());
}
