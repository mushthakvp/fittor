import 'package:flutter/material.dart';

import 'blur_hash.dart';

class FittorBlurAsh extends StatefulWidget {
  final String hash;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? child;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final int resolution;

  const FittorBlurAsh({
    super.key,
    required this.hash,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.child,
    this.loadingWidget,
    this.errorWidget,
    this.resolution = 32,
  });

  @override
  State<FittorBlurAsh> createState() => _FittorBlurAshState();
}

class _FittorBlurAshState extends State<FittorBlurAsh> {
  late final ValueNotifier<Future<ImageProvider>> _imageFutureNotifier;

  @override
  void initState() {
    super.initState();
    _imageFutureNotifier = ValueNotifier(_buildImageFuture());
  }

  @override
  void didUpdateWidget(covariant FittorBlurAsh oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hash != widget.hash ||
        oldWidget.resolution != widget.resolution) {
      _imageFutureNotifier.value = _buildImageFuture();
    }
  }

  Future<ImageProvider> _buildImageFuture() {
    final width = (widget.width ?? widget.resolution.toDouble()).toInt();
    final height = (widget.height ?? widget.resolution.toDouble()).toInt();
    return BlurHashDecoder.decodeToImage(widget.hash, width, height);
  }

  @override
  void dispose() {
    _imageFutureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ValueListenableBuilder<Future<ImageProvider>>(
        valueListenable: _imageFutureNotifier,
        builder: (context, future, _) {
          return FutureBuilder<ImageProvider>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: snapshot.data!,
                        width: widget.width,
                        height: widget.height,
                        fit: widget.fit,
                        color: widget.color,
                      ),
                      if (widget.child != null) widget.child!,
                    ],
                  );
                } else if (snapshot.hasError) {
                  return widget.errorWidget ?? _placeholder();
                }
              }
              return widget.loadingWidget ?? _placeholder();
            },
          );
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade300,
    );
  }
}
