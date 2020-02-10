import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wechat/service/base.dart';

class UImage extends StatefulWidget {
  const UImage(
    String url, {
    Key key,
    this.width,
    this.height,
    this.filterQuality = FilterQuality.low,
    this.fit = BoxFit.fill,
    this.placeholderBuilder,
    this.errorWidgetBuilder,
    this.onLoad,
    this.onError,
    this.whenComplete,
  })  : url = url ?? '',
        super(key: key);

  final WidgetBuilder placeholderBuilder;
  final WidgetBuilder errorWidgetBuilder;
  final void Function(ImageInfo imageInfo) onLoad;
  final VoidCallback onError;
  final VoidCallback whenComplete;
  final double width;
  final double height;
  final String url;
  final FilterQuality filterQuality;
  final BoxFit fit;

  @override
  _UImageState createState() => _UImageState();
}

class _UImageState extends State<UImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.url.startsWith('asset://')) {
      return ExtendedImage.asset(
        widget.url.substring('asset://'.length),
        filterQuality: widget.filterQuality,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        enableLoadState: true,
        enableMemoryCache: true,
        clearMemoryCacheIfFailed: true,
        loadStateChanged: _onLoadStateChanged,
      );
    }
    return ExtendedImage.network(
      widget.url.startsWith('http://') || widget.url.startsWith('https://')
          ? widget.url
          : staticFileBaseUrl +
              (widget.url.startsWith('/') ? widget.url : '/' + widget.url),
      filterQuality: widget.filterQuality,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      enableLoadState: true,
      enableMemoryCache: !kIsWeb,
      clearMemoryCacheIfFailed: true,
      cache: !kIsWeb,
      loadStateChanged: _onLoadStateChanged,
    );
  }

  Widget _buildPlaceholder() => widget.placeholderBuilder == null
      ? SizedBox(width: widget.width, height: widget.height)
      : (widget.placeholderBuilder(context) ?? Container());

  Widget _buildErrorWidget() => widget.errorWidgetBuilder == null
      ? _buildPlaceholder()
      : (widget.errorWidgetBuilder(context) ?? Container());

  void _whenComplete() {
    if (widget.whenComplete != null) {
      widget.whenComplete();
    }
  }

  void _onLoad(ImageInfo imageInfo) {
    if (widget.onLoad != null) {
      widget.onLoad(imageInfo);
    }
    _whenComplete();
  }

  void _onError() {
    if (widget.onError != null) {
      widget.onError();
    }
    _whenComplete();
  }

  Widget _onLoadStateChanged(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.completed:
        _onLoad(state.extendedImageInfo);
        return null;
      case LoadState.failed:
        _onError();
        return _buildErrorWidget();
      default:
        return _buildPlaceholder();
    }
  }
}
