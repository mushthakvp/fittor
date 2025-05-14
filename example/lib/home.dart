import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

String svgContent = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11 14.75C10.3096 14.75 9.74998 15.3096 9.74998 16C9.74998 16.6904 10.3096 17.25 11 17.25C11.6903 17.25 12.25 16.6904 12.25 16C12.25 15.3096 11.6903 14.75 11 14.75Z" fill="#1C274C"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M8.25014 6.01489C8.25005 6.00994 8.25 6.00498 8.25 6V5C8.25 2.92893 9.92893 1.25 12 1.25C14.0711 1.25 15.75 2.92893 15.75 5V6C15.75 6.00498 15.75 6.00994 15.7499 6.0149C17.0371 6.05353 17.8248 6.1924 18.4261 6.69147C19.2593 7.38295 19.4787 8.55339 19.9177 10.8943L20.6677 14.8943C21.2849 18.186 21.5934 19.8318 20.6937 20.9159C19.794 22 18.1195 22 14.7704 22H9.22954C5.88048 22 4.20595 22 3.30624 20.9159C2.40652 19.8318 2.71512 18.186 3.33231 14.8943L4.08231 10.8943C4.52122 8.55339 4.74068 7.38295 5.57386 6.69147C6.17521 6.19239 6.96288 6.05353 8.25014 6.01489ZM9.75 5C9.75 3.75736 10.7574 2.75 12 2.75C13.2426 2.75 14.25 3.75736 14.25 5V6C14.25 5.99999 14.25 6.00001 14.25 6C14.1747 5.99998 14.0982 6 14.0204 6H9.97954C9.90177 6 9.82526 6 9.75 6.00002C9.75 6.00002 9.75 6.00003 9.75 6.00002V5ZM13.75 10C13.75 9.58579 13.4142 9.25 13 9.25C12.5858 9.25 12.25 9.58579 12.25 10V13.5499C11.8749 13.3581 11.4501 13.25 11 13.25C9.4812 13.25 8.24998 14.4812 8.24998 16C8.24998 17.5188 9.4812 18.75 11 18.75C12.5188 18.75 13.75 17.5188 13.75 16V12.4501C14.125 12.6419 14.5499 12.75 15 12.75C15.4142 12.75 15.75 12.4142 15.75 12C15.75 11.5858 15.4142 11.25 15 11.25C14.3096 11.25 13.75 10.6904 13.75 10Z" fill="#1C274C"/>
</svg>
''';

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
            // Direct SVG string
            SvgImage(
              svgString: svgContent,
              width: 100,
              height: 100,
              color: Color(0xff1C274C),
            ),
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
          ],
        ),
        16.h,
        Text('Vertical Spacers', style: TextStyle(fontSize: context.fs(16))),
        Column(
          children: [
            Container(color: Colors.red, height: 4),
            5.h,
            Container(color: Colors.green, height: 6),
            10.h,
            Container(color: Colors.blue, height: 8),
            15.h,
            Container(color: Colors.orange, height: 10),
          ],
        ),
      ],
    );
  }

  Widget _buildSpacingBox(BuildContext context, String label, double size) {
    return Container(
      width: size * 6,
      height: size * 6,
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
          'Font Size Examples  10.h',
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
          'Height 10 --10.h--',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Height 20 --20.h--',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
