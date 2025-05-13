import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Responsive Demo',
          style: TextStyle(fontSize: context.fs(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom SizedBox Examples
            _buildCustomSizedBoxExamples(context),
            // Device Info Section
            _buildDeviceInfoSection(context),

            // Spacing Examples
            _buildSpacingExamples(context),

            // Sizing Examples
            _buildSizingExamples(context),

            // Font Size Examples
            _buildFontSizeExamples(context),

            // Adaptive Widget Example
            _buildAdaptiveWidgetExample(context),

            // Safe Area Example
            _buildSafeAreaExample(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: TextStyle(
                fontSize: context.fs(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            8.h,
            Text('Screen Width: ${context.width}'),
            Text('Screen Height: ${context.height}'),
            Text(
              'Orientation: ${FittorHelper.isPortrait ? 'Portrait' : 'Landscape'}',
            ),
            Text(
              'Device Type: ${FittorHelper.isMobile
                  ? 'Mobile'
                  : FittorHelper.isTablet
                  ? 'Tablet'
                  : 'Desktop'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.h,
        Text(
          'Spacing Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        8.h,
        Wrap(
          spacing: context.p8,
          runSpacing: context.p8,
          children: [
            _buildSpacingBox(context, 'p4', context.p4),
            _buildSpacingBox(context, 'p8', context.p8),
            _buildSpacingBox(context, 'p12', context.p12),
            _buildSpacingBox(context, 'p16', context.p16),
            _buildSpacingBox(context, 'p20', context.p20),
            _buildSpacingBox(context, 'p24', context.p24),
          ],
        ),
        16.h,
        Text('Vertical Spacers', style: TextStyle(fontSize: context.fs(16))),
        Column(
          children: [
            Container(color: Colors.red, height: 2),
            .5.h,
            Container(color: Colors.green, height: 2),
            1.h,
            Container(color: Colors.blue, height: 2),
            2.h,
            Container(color: Colors.orange, height: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildSpacingBox(BuildContext context, String label, double size) {
    return Container(
      width: size * 3,
      height: size * 3,
      color: Colors.blue.withOpacity(0.5),
      alignment: Alignment.center,
      child: Text(label),
    );
  }

  Widget _buildSizingExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.h,
        Text(
          'Sizing Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        8.h,
        Text('Percentage of Screen Width/Height'),
        8.h,
        Container(
          width: context.wp(80),
          height: context.hp(15),
          color: Colors.amber,
          alignment: Alignment.center,
          child: Text('80% width, 15% height'),
        ),
        16.h,
        Text('Scaled Containers'),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: context.scaleWidth(100),
              height: context.scaleHeight(50),
              color: Colors.red.withOpacity(0.5),
              alignment: Alignment.center,
              child: Text('Scale W100'),
            ),
            Container(
              width: context.scaleWidth(150),
              height: context.scaleHeight(75),
              color: Colors.green.withOpacity(0.5),
              alignment: Alignment.center,
              child: Text('Scale W150'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFontSizeExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.h,
        Text(
          'Font Size Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        8.h,
        Text('Fixed Size (fs16)', style: TextStyle(fontSize: context.fs(16))),
        Text(
          'Adaptive Size (adaptiveFs16)',
          style: TextStyle(fontSize: context.adaptiveFs(16)),
        ),
        8.h,
        Text('Predefined Sizes:', style: TextStyle(fontSize: context.fs(14))),
        4.h,
        Text('fs12', style: TextStyle(fontSize: context.fs12)),
        Text('fs16', style: TextStyle(fontSize: context.fs16)),
        Text('fs20', style: TextStyle(fontSize: context.fs20)),
        Text('fs24', style: TextStyle(fontSize: context.fs24)),
        Text('fs32', style: TextStyle(fontSize: context.fs32)),
      ],
    );
  }

  Widget _buildAdaptiveWidgetExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.h,
        Text(
          'Adaptive Widgets',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        8.h,
        Container(
          padding: EdgeInsets.all(
            context.deviceValue(
              mobile: context.p8,
              tablet: context.p16,
              desktop: context.p24,
            ),
          ),
          color: Colors.purple.withOpacity(0.2),
          child: Text(
            'This padding changes by device',
            style: TextStyle(fontSize: context.adaptiveFs(16)),
          ),
        ),
        16.h,
        Container(
          width: context.adaptiveSize(200),
          height: context.adaptiveSize(100),
          color: Colors.teal.withOpacity(0.3),
          alignment: Alignment.center,
          child: Text(
            'Adaptive Container',
            style: TextStyle(fontSize: context.adaptiveFs(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildSafeAreaExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.h,
        Text(
          'Safe Area Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        8.h,
        Container(
          width: context.swp(90), // Safe width percentage
          height: context.shp(10), // Safe height percentage
          color: Colors.orange.withOpacity(0.3),
          alignment: Alignment.center,
          child: Text(
            '90% of safe width\n10% of safe height',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSizedBoxExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height 10',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        10.h,
        Text(
          'Height 20',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        20.h,
      ],
    );
  }
}
