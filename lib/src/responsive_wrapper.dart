import 'package:flutter/material.dart';

import '../responsive.dart';

mixin ResponsiveAppMixin on Widget {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            ResponsiveHelper().init(context, constraints, orientation);
            return responsive(context);
          },
        );
      },
    );
  }

  Widget responsive(BuildContext context);
}
