import 'package:flutter/material.dart';

import '../fittor.dart';

mixin FittorAppMixin on Widget {
  Widget build(BuildContext context) {
    // FittorErrorHandler.initialize();
    // return FittorErrorBoundary(
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            FittorHelper().init(context, constraints, orientation);
            return responsive(context);
          },
        );
      },
      // ),
    );
  }

  Widget responsive(BuildContext context);
}
