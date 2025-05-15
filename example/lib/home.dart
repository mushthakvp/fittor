import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/no_internet.dart';

String svgContent = '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M13.8498 0.500648C14.4808 0.500648 15.1108 0.589648 15.7098 0.790648C19.4008 1.99065 20.7308 6.04065 19.6198 9.58065C18.9898 11.3896 17.9598 13.0406 16.6108 14.3896C14.6798 16.2596 12.5608 17.9196 10.2798 19.3496L10.0298 19.5006L9.7698 19.3396C7.4808 17.9196 5.3498 16.2596 3.4008 14.3796C2.0608 13.0306 1.0298 11.3896 0.389803 9.58065C-0.740197 6.04065 0.589803 1.99065 4.3208 0.769648C4.6108 0.669648 4.9098 0.599648 5.2098 0.560648H5.3298C5.6108 0.519648 5.8898 0.500648 6.1698 0.500648H6.2798C6.9098 0.519648 7.5198 0.629648 8.1108 0.830648H8.1698C8.2098 0.849648 8.2398 0.870648 8.2598 0.889648C8.4808 0.960648 8.6898 1.04065 8.8898 1.15065L9.2698 1.32065C9.36162 1.36962 9.46469 1.44445 9.55376 1.50912C9.6102 1.55009 9.66102 1.58699 9.6998 1.61065C9.71612 1.62028 9.73271 1.62996 9.74943 1.63972C9.83517 1.68977 9.92449 1.74191 9.9998 1.79965C11.1108 0.950648 12.4598 0.490648 13.8498 0.500648ZM16.5098 7.70065C16.9198 7.68965 17.2698 7.36065 17.2998 6.93965V6.82065C17.3298 5.41965 16.4808 4.15065 15.1898 3.66065C14.7798 3.51965 14.3298 3.74065 14.1798 4.16065C14.0398 4.58065 14.2598 5.04065 14.6798 5.18965C15.3208 5.42965 15.7498 6.06065 15.7498 6.75965V6.79065C15.7308 7.01965 15.7998 7.24065 15.9398 7.41065C16.0798 7.58065 16.2898 7.67965 16.5098 7.70065Z" fill="url(#paint0_linear_35_59)"/>
<defs>
<linearGradient id="paint0_linear_35_59" x1="20" y1="19.5006" x2="-3.60073" y2="12.2977" gradientUnits="userSpaceOnUse">
<stop stop-color="#123F6D"/>
<stop offset="1" stop-color="#7369F8"/>
</linearGradient>
</defs>
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NoInternet()),
              );
            },
            icon: Icon(Icons.wifi_off, size: 30, color: Colors.red),
          ),
        ],
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
