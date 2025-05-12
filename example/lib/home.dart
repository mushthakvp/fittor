import 'package:flutter/material.dart';
import 'package:responsive/responsive.dart';

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
            context.s8,
            Text('Screen Width: ${context.width}'),
            Text('Screen Height: ${context.height}'),
            Text(
              'Orientation: ${ResponsiveHelper.isPortrait ? 'Portrait' : 'Landscape'}',
            ),
            Text(
              'Device Type: ${ResponsiveHelper.isMobile
                  ? 'Mobile'
                  : ResponsiveHelper.isTablet
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
        context.s16,
        Text(
          'Spacing Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        context.s8,
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
        context.s16,
        Text('Vertical Spacers', style: TextStyle(fontSize: context.fs(16))),
        Column(
          children: [
            Container(color: Colors.red, height: 2),
            context.s_5,
            Container(color: Colors.green, height: 2),
            context.s1,
            Container(color: Colors.blue, height: 2),
            context.s2,
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
        context.s20,
        Text(
          'Sizing Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        context.s8,
        Text('Percentage of Screen Width/Height'),
        context.s8,
        Container(
          width: context.wp(80),
          height: context.hp(15),
          color: Colors.amber,
          alignment: Alignment.center,
          child: Text('80% width, 15% height'),
        ),
        context.s16,
        Text('Scaled Containers'),
        context.s8,
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
        context.s20,
        Text(
          'Font Size Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        context.s8,
        Text('Fixed Size (fs16)', style: TextStyle(fontSize: context.fs(16))),
        Text(
          'Adaptive Size (adaptiveFs16)',
          style: TextStyle(fontSize: context.adaptiveFs(16)),
        ),
        context.s8,
        Text('Predefined Sizes:', style: TextStyle(fontSize: context.fs(14))),
        context.s4,
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
        context.s20,
        Text(
          'Adaptive Widgets',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        context.s8,
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
        context.s16,
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
        context.s20,
        Text(
          'Safe Area Examples',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        context.s8,
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
}
