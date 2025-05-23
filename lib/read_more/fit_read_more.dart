// lib/read_more/src/fit_read_more.dart
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:fittor/fittor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const String _kEllipsis = '\u2026';
const String _kLineSeparator = '\u2028';

/// A customizable Flutter widget that provides "read more" and "read less" functionality
/// for long text content with support for annotations, styling, and trimming options.
class FitReadMore extends StatefulWidget {
  /// Creates a FitReadMore widget with plain text.
  const FitReadMore(
    String this.data, {
    super.key,
    this.isCollapsed,
    this.preDataText,
    this.postDataText,
    this.preDataTextStyle,
    this.postDataTextStyle,
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.colorClickableText,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = TrimMode.length,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '$_kEllipsis ',
    this.delimiterStyle,
    this.annotations,
    this.isExpandable = true,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.onExpanded,
    this.onCollapsed,
  })  : richData = null,
        richPreData = null,
        richPostData = null;

  /// Creates a FitReadMore widget with rich text.
  const FitReadMore.rich(
    TextSpan this.richData, {
    super.key,
    this.richPreData,
    this.richPostData,
    this.isCollapsed,
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.colorClickableText,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = TrimMode.length,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '$_kEllipsis ',
    this.delimiterStyle,
    this.isExpandable = true,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.onExpanded,
    this.onCollapsed,
  })  : data = null,
        annotations = null,
        preDataText = null,
        postDataText = null,
        preDataTextStyle = null,
        postDataTextStyle = null;

  /// The text data to display
  final String? data;

  /// Rich text data to display
  final TextSpan? richData;

  /// External controller for collapse/expand state
  final ValueNotifier<bool>? isCollapsed;

  /// Text to display before the main data
  final String? preDataText;

  /// Text to display after the main data
  final String? postDataText;

  /// Style for pre-data text
  final TextStyle? preDataTextStyle;

  /// Style for post-data text
  final TextStyle? postDataTextStyle;

  /// Rich version of preDataText
  final TextSpan? richPreData;

  /// Rich version of postDataText
  final TextSpan? richPostData;

  /// Maximum character length when using TrimMode.length
  final int trimLength;

  /// Maximum number of lines when using TrimMode.line
  final int trimLines;

  /// Determines how text should be trimmed
  final TrimMode trimMode;

  /// Text to show when expanded (e.g., "show less")
  final String trimExpandedText;

  /// Text to show when collapsed (e.g., "read more")
  final String trimCollapsedText;

  /// Color for clickable text (read more/less)
  final Color? colorClickableText;

  /// Style for "read more" text
  final TextStyle? moreStyle;

  /// Style for "read less" text
  final TextStyle? lessStyle;

  /// Delimiter text (usually ellipsis)
  final String delimiter;

  /// Style for delimiter text
  final TextStyle? delimiterStyle;

  /// List of text annotations for pattern matching
  final List<FitAnnotation>? annotations;

  /// Whether the text can be expanded/collapsed
  final bool isExpandable;

  /// Callback when text is expanded
  final VoidCallback? onExpanded;

  /// Callback when text is collapsed
  final VoidCallback? onCollapsed;

  // Text widget properties
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  State<FitReadMore> createState() => _FitReadMoreState();
}

class _FitReadMoreState extends State<FitReadMore> {
  final TapGestureRecognizer _recognizer = TapGestureRecognizer();
  ValueNotifier<bool>? _isCollapsed;

  ValueNotifier<bool> get _effectiveIsCollapsed =>
      widget.isCollapsed ?? (_isCollapsed ??= ValueNotifier(true));

  @override
  void initState() {
    super.initState();
    _recognizer.onTap = _onTap;
  }

  @override
  void didUpdateWidget(FitReadMore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCollapsed == null && oldWidget.isCollapsed != null) {
      final oldValue = oldWidget.isCollapsed!.value;
      (_isCollapsed ??= ValueNotifier(oldValue)).value = oldValue;
    }
  }

  @override
  void dispose() {
    _recognizer.dispose();
    _isCollapsed?.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.isExpandable) {
      final wasCollapsed = _effectiveIsCollapsed.value;
      _effectiveIsCollapsed.value = !wasCollapsed;

      if (wasCollapsed) {
        widget.onExpanded?.call();
      } else {
        widget.onCollapsed?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _effectiveIsCollapsed,
      builder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, bool isCollapsed, Widget? child) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final effectiveTextStyle =
        _getEffectiveTextStyle(defaultTextStyle, context);
    final colorClickableText =
        widget.colorClickableText ?? Theme.of(context).colorScheme.secondary;

    return LayoutBuilder(
      builder: (context, constraints) => _buildContent(
        context,
        constraints,
        isCollapsed,
        effectiveTextStyle,
        colorClickableText,
      ),
    );
  }

  TextStyle _getEffectiveTextStyle(
      DefaultTextStyle defaultTextStyle, BuildContext context) {
    TextStyle effectiveTextStyle;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    } else {
      effectiveTextStyle = widget.style!;
    }

    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }

    return effectiveTextStyle;
  }

  Widget _buildContent(
    BuildContext context,
    BoxConstraints constraints,
    bool isCollapsed,
    TextStyle effectiveTextStyle,
    Color colorClickableText,
  ) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final registrar = SelectionContainer.maybeOf(context);
    final textScaler = widget.textScaler ?? MediaQuery.textScalerOf(context);

    // Get effective properties
    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);
    final softWrap = widget.softWrap ?? defaultTextStyle.softWrap;
    final overflow = widget.overflow ?? defaultTextStyle.overflow;
    final textWidthBasis =
        widget.textWidthBasis ?? defaultTextStyle.textWidthBasis;
    final textHeightBehavior = widget.textHeightBehavior ??
        defaultTextStyle.textHeightBehavior ??
        DefaultTextHeightBehavior.maybeOf(context);
    final selectionColor = widget.selectionColor ??
        DefaultSelectionStyle.of(context).selectionColor ??
        DefaultSelectionStyle.defaultColor;

    // Create styles
    final defaultLessStyle = widget.lessStyle ??
        effectiveTextStyle.copyWith(color: colorClickableText);
    final defaultMoreStyle = widget.moreStyle ??
        effectiveTextStyle.copyWith(color: colorClickableText);
    final defaultDelimiterStyle = widget.delimiterStyle ?? effectiveTextStyle;

    // Create text spans
    final link = TextSpan(
      text: isCollapsed ? widget.trimCollapsedText : widget.trimExpandedText,
      style: isCollapsed ? defaultMoreStyle : defaultLessStyle,
      recognizer: _recognizer,
    );

    final delimiter = TextSpan(
      text: isCollapsed && widget.trimCollapsedText.isNotEmpty
          ? widget.delimiter
          : '',
      style: defaultDelimiterStyle,
      recognizer: _recognizer,
    );

    // Build the main text content
    final textSpan = _buildMainTextSpan(
      context,
      constraints,
      isCollapsed,
      effectiveTextStyle,
      link,
      delimiter,
      textAlign,
      textDirection,
      locale,
      textScaler,
    );

    Widget result = RichText(
      text: textSpan,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      strutStyle: widget.strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionRegistrar: registrar,
      selectionColor: selectionColor,
    );

    // Add mouse region for text selection
    if (registrar != null) {
      result = MouseRegion(
        cursor: DefaultSelectionStyle.of(context).mouseCursor ??
            SystemMouseCursors.text,
        child: result,
      );
    }

    // Add semantics
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(child: result),
      );
    }

    return result;
  }

  TextSpan _buildMainTextSpan(
    BuildContext context,
    BoxConstraints constraints,
    bool isCollapsed,
    TextStyle effectiveTextStyle,
    TextSpan link,
    TextSpan delimiter,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale? locale,
    TextScaler textScaler,
  ) {
    // Build pre and post text spans
    final preTextSpan = _buildPreTextSpan(effectiveTextStyle);
    final postTextSpan = _buildPostTextSpan(effectiveTextStyle);
    final dataTextSpan = _buildDataTextSpan(effectiveTextStyle);

    // Create combined text span for measurement
    final fullTextSpan = TextSpan(
      children: [
        if (preTextSpan != null) preTextSpan,
        dataTextSpan,
        if (postTextSpan != null) postTextSpan,
      ],
    );

    final trimmedTextSpan = _getTrimmedTextSpan(
      fullTextSpan,
      dataTextSpan,
      isCollapsed,
      link,
      delimiter,
      constraints,
      textAlign,
      textDirection,
      locale,
      textScaler,
    );

    return TextSpan(
      children: [
        if (preTextSpan != null) preTextSpan,
        trimmedTextSpan,
        if (postTextSpan != null) postTextSpan,
      ],
    );
  }

  TextSpan? _buildPreTextSpan(TextStyle effectiveTextStyle) {
    if (widget.richPreData != null) {
      return widget.richPreData;
    } else if (widget.preDataText != null) {
      return TextSpan(
        text: '${widget.preDataText!} ',
        style: widget.preDataTextStyle ?? effectiveTextStyle,
      );
    }
    return null;
  }

  TextSpan? _buildPostTextSpan(TextStyle effectiveTextStyle) {
    if (widget.richPostData != null) {
      return widget.richPostData;
    } else if (widget.postDataText != null) {
      return TextSpan(
        text: ' ${widget.postDataText!}',
        style: widget.postDataTextStyle ?? effectiveTextStyle,
      );
    }
    return null;
  }

  TextSpan _buildDataTextSpan(TextStyle effectiveTextStyle) {
    if (widget.richData != null) {
      return TextSpan(
        style: effectiveTextStyle,
        children: [widget.richData!],
      );
    } else {
      return _buildAnnotatedTextSpan(
        data: widget.data!,
        textStyle: effectiveTextStyle,
      );
    }
  }

  TextSpan _buildAnnotatedTextSpan({
    required String data,
    required TextStyle textStyle,
  }) {
    final regExp = TextSpanUtils.mergeRegexPatterns(widget.annotations);

    if (regExp == null || data.isEmpty) {
      return TextSpan(text: data, style: textStyle);
    }

    final contents = <TextSpan>[];

    data.splitMapJoin(
      regExp,
      onMatch: (Match regexMatch) {
        final matchedText = regexMatch.group(0)!;
        late final FitAnnotation matchedAnnotation;

        if (widget.annotations!.length == 1) {
          matchedAnnotation = widget.annotations![0];
        } else {
          for (var i = 0; i < regexMatch.groupCount; i++) {
            if (matchedText == regexMatch.group(i + 1)) {
              matchedAnnotation = widget.annotations![i];
              break;
            }
          }
        }

        final content = matchedAnnotation.spanBuilder(
          text: matchedText,
          textStyle: textStyle,
        );

        contents.add(content);
        return '';
      },
      onNonMatch: (String unmatchedText) {
        contents.add(TextSpan(text: unmatchedText));
        return '';
      },
    );

    return TextSpan(style: textStyle, children: contents);
  }

  TextSpan _getTrimmedTextSpan(
    TextSpan fullTextSpan,
    TextSpan dataTextSpan,
    bool isCollapsed,
    TextSpan link,
    TextSpan delimiter,
    BoxConstraints constraints,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale? locale,
    TextScaler textScaler,
  ) {
    switch (widget.trimMode) {
      case TrimMode.length:
        return _getTrimmedByLength(dataTextSpan, isCollapsed, link, delimiter);
      case TrimMode.line:
        return _getTrimmedByLine(
          fullTextSpan,
          dataTextSpan,
          isCollapsed,
          link,
          delimiter,
          constraints,
          textAlign,
          textDirection,
          locale,
          textScaler,
        );
    }
  }

  TextSpan _getTrimmedByLength(
    TextSpan dataTextSpan,
    bool isCollapsed,
    TextSpan link,
    TextSpan delimiter,
  ) {
    final data = widget.richData != null ? null : widget.data!;

    if (widget.richData != null) {
      final trimResult = _trimTextSpan(
        textSpan: dataTextSpan,
        spanStartIndex: 0,
        endIndex: widget.trimLength,
        splitByRunes: true,
      );

      if (trimResult.didTrim) {
        return TextSpan(
          children: [
            if (isCollapsed) trimResult.textSpan else dataTextSpan,
            delimiter,
            link,
          ],
        );
      } else {
        return dataTextSpan;
      }
    } else {
      if (widget.trimLength < data!.runes.length) {
        final effectiveDataTextSpan = isCollapsed
            ? _trimTextSpan(
                textSpan: dataTextSpan,
                spanStartIndex: 0,
                endIndex: widget.trimLength,
                splitByRunes: true,
              ).textSpan
            : dataTextSpan;

        return TextSpan(
          children: [
            effectiveDataTextSpan,
            delimiter,
            link,
          ],
        );
      } else {
        return dataTextSpan;
      }
    }
  }

  TextSpan _getTrimmedByLine(
    TextSpan fullTextSpan,
    TextSpan dataTextSpan,
    bool isCollapsed,
    TextSpan link,
    TextSpan delimiter,
    BoxConstraints constraints,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale? locale,
    TextScaler textScaler,
  ) {
    // Create text painter for measurement
    final textPainter = TextPainter(
      text: link,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      textScaler: textScaler,
      maxLines: widget.trimLines,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: widget.textHeightBehavior,
    );

    final maxWidth = constraints.maxWidth;

    // Measure link
    textPainter.layout(maxWidth: maxWidth);
    final linkSize = textPainter.size;

    // Measure delimiter
    textPainter.text = delimiter;
    textPainter.layout(maxWidth: maxWidth);
    final delimiterSize = textPainter.size;

    // Measure full text
    textPainter.text = fullTextSpan;
    textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
    final textSize = textPainter.size;

    if (textPainter.didExceedMaxLines) {
      var linkLongerThanLine = false;
      int endIndex;

      if (linkSize.width < maxWidth) {
        final readMoreSize = linkSize.width + delimiterSize.width;
        final pos = textPainter.getPositionForOffset(
          Offset(
            textDirection == TextDirection.rtl
                ? readMoreSize
                : textSize.width - readMoreSize,
            textSize.height,
          ),
        );
        endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
      } else {
        final pos = textPainter.getPositionForOffset(
          textSize.bottomLeft(Offset.zero),
        );
        endIndex = pos.offset;
        linkLongerThanLine = true;
      }

      final effectiveDataTextSpan = isCollapsed
          ? _trimTextSpan(
              textSpan: dataTextSpan,
              spanStartIndex: 0,
              endIndex: endIndex,
              splitByRunes: false,
            ).textSpan
          : dataTextSpan;

      return TextSpan(
        children: [
          effectiveDataTextSpan,
          if (linkLongerThanLine) const TextSpan(text: _kLineSeparator),
          delimiter,
          link,
        ],
      );
    } else {
      return dataTextSpan;
    }
  }

  TextSpanTrimResult _trimTextSpan({
    required TextSpan textSpan,
    required int spanStartIndex,
    required int endIndex,
    required bool splitByRunes,
  }) {
    var spanEndIndex = spanStartIndex;

    final text = textSpan.text;
    if (text != null) {
      final textLen = splitByRunes ? text.runes.length : text.length;
      spanEndIndex += textLen;

      if (spanEndIndex >= endIndex) {
        final newText = splitByRunes
            ? String.fromCharCodes(text.runes, 0, endIndex - spanStartIndex)
            : text.substring(0, endIndex - spanStartIndex);

        final nextSpan = TextSpan(
          text: newText,
          children: null,
          style: textSpan.style,
          recognizer: textSpan.recognizer,
          mouseCursor: textSpan.mouseCursor,
          onEnter: textSpan.onEnter,
          onExit: textSpan.onExit,
          semanticsLabel: textSpan.semanticsLabel,
          locale: textSpan.locale,
          spellOut: textSpan.spellOut,
        );

        return TextSpanTrimResult(
          textSpan: nextSpan,
          spanEndIndex: spanEndIndex,
          didTrim: true,
        );
      }
    }

    var didTrim = false;
    final newChildren = <InlineSpan>[];

    final children = textSpan.children;
    if (children != null) {
      for (final child in children) {
        if (child is TextSpan) {
          final result = _trimTextSpan(
            textSpan: child,
            spanStartIndex: spanEndIndex,
            endIndex: endIndex,
            splitByRunes: splitByRunes,
          );

          spanEndIndex = result.spanEndIndex;
          newChildren.add(result.textSpan);

          if (result.didTrim) {
            didTrim = true;
            break;
          }
        } else {
          newChildren.add(child);
        }
      }
    }

    final resultTextSpan = didTrim
        ? TextSpan(
            text: textSpan.text,
            children: newChildren,
            style: textSpan.style,
            recognizer: textSpan.recognizer,
            mouseCursor: textSpan.mouseCursor,
            onEnter: textSpan.onEnter,
            onExit: textSpan.onExit,
            semanticsLabel: textSpan.semanticsLabel,
            locale: textSpan.locale,
            spellOut: textSpan.spellOut,
          )
        : textSpan;

    return TextSpanTrimResult(
      textSpan: resultTextSpan,
      spanEndIndex: spanEndIndex,
      didTrim: didTrim,
    );
  }
}
