import 'package:flutter/material.dart';

import '../adaptix_helper.dart';

mixin AdaptixAppMixin on Widget {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            AdaptixHelper().init(context, constraints, orientation);
            return responsive(context);
          },
        );
      },
    );
  }

  Widget responsive(BuildContext context);
}
