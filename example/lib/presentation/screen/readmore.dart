import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class FitReadMoreExample extends StatefulWidget {
  const FitReadMoreExample({super.key});

  @override
  State<FitReadMoreExample> createState() => _FitReadMoreExampleState();
}

class _FitReadMoreExampleState extends State<FitReadMoreExample> {
  final ValueNotifier<bool> _isCollapsed = ValueNotifier(true);

  final String longText = '''
Lorem ipsum dolor sit abet, connecter advising edit. Sed do elusion tempo incident ut labors et dolor magna aqua. Ut enid ad minim veinal, ques nostrum exercitation ullage labors nisi ut aliquot ex ea comodo consequent. Dais ante inure dolor in reprehended in voluptatem veldt esse cilium dolor eu fugit null pariah. Excepted snit occaecat cupidity non provident, sent in culpa qui officio desert mollie anim id est labrum.

Visit our website at https://example.com or follow us @fittor_package for more updates! You can also check out #FlutterDev and #MobileDevelopment for related content.

Sed ut presidia undy omanis isle nats error sit voluptatem accusant dole laudanum, totem rem aerial, ease ipas quae ab ilo inventor veritas et quasi architects berate vitae dicta sent explicable.
  ''';

  @override
  void dispose() {
    _isCollapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FitReadMore Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Example
            _buildSection(
              'Basic ReadMore',
              FitReadMore(
                longText,
                trimLength: 150,
                trimMode: TrimMode.length,
                colorClickableText: Colors.blue,
                moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Line-based trimming
            _buildSection(
              'Trim by Lines',
              FitReadMore(
                longText,
                trimLines: 3,
                trimMode: TrimMode.line,
                colorClickableText: Colors.green,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
              ),
            ),

            // With Pre/Post Data
            _buildSection(
              'With Pre/Post Text',
              FitReadMore(
                longText,
                preDataText: '📝 Article:',
                postDataText: '- End of article',
                preDataTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                postDataTextStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                trimLength: 200,
              ),
            ),

            // With Annotations (URLs, hashtags, mentions)
            _buildSection(
              'With Annotations',
              FitReadMore(
                longText,
                trimLength: 300,
                annotations: [
                  // URL annotation
                  FitAnnotation(
                    regExp: RegExp(r'https?://[^\s]+'),
                    spanBuilder:
                        ({required text, required textStyle}) => TextSpan(
                          text: text,
                          style: textStyle.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                  ),
                  // Hashtag annotation
                  FitAnnotation(
                    regExp: RegExp(r'#\w+'),
                    spanBuilder:
                        ({required text, required textStyle}) => TextSpan(
                          text: text,
                          style: textStyle.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                  // Mention annotation
                  FitAnnotation(
                    regExp: RegExp(r'@\w+'),
                    spanBuilder:
                        ({required text, required textStyle}) => TextSpan(
                          text: text,
                          style: textStyle.copyWith(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ],
              ),
            ),

            // Rich Text Example
            _buildSection(
              'Rich Text Example',
              FitReadMore.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'This is ',
                      style: TextStyle(color: Colors.black),
                    ),
                    const TextSpan(
                      text: 'bold text',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const TextSpan(
                      text: ' and this is ',
                      style: TextStyle(color: Colors.black),
                    ),
                    const TextSpan(
                      text: 'italic text',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: '. $longText',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                trimLength: 100,
              ),
            ),

            // Controlled Example
            _buildSection(
              'Controlled ReadMore',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FitReadMore(
                    longText,
                    isCollapsed: _isCollapsed,
                    trimLength: 180,
                    onExpanded: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Text expanded!')),
                      );
                    },
                    onCollapsed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Text collapsed!')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _isCollapsed.value = !_isCollapsed.value;
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isCollapsed,
                      builder: (context, isCollapsed, child) {
                        return Text(isCollapsed ? 'Expand' : 'Collapse');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Non-expandable Example
            _buildSection(
              'Non-Expandable (Display Only)',
              FitReadMore(
                longText,
                trimLength: 120,
                isExpandable: false,
                colorClickableText: Colors.grey,
                trimCollapsedText: '... (truncated)',
              ),
            ),

            // Custom Styling Example
            _buildSection(
              'Custom Styling',
              FitReadMore(
                longText,
                trimLength: 160,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
                delimiter: ' ••• ',
                delimiterStyle: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
                moreStyle: const TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                lessStyle: const TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                trimCollapsedText: 'Read full article',
                trimExpandedText: 'Show summary',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
