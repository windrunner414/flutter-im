import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wechat/service/base.dart';

class UImage extends StatelessWidget {
  UImage(
    this.url, {
    Key key,
    this.width,
    this.height,
    this.filterQuality = FilterQuality.low,
    this.fit = BoxFit.fill,
    Widget placeholder,
    this.onComplete,
    this.onFailed,
  })  : assert(url != null),
        placeholder = placeholder ?? SizedBox(width: width, height: height),
        super(key: key);

  final Widget placeholder;
  final VoidCallback onComplete;
  final Widget Function() onFailed;
  final double width;
  final double height;
  final String url;
  final FilterQuality filterQuality;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    const String assetUrlStart = 'asset://';
    if (url.startsWith(assetUrlStart)) {
      return ExtendedImage.asset(
        url.substring(assetUrlStart.length),
        filterQuality: filterQuality,
        fit: fit,
        width: width,
        height: height,
        enableLoadState: true,
        enableMemoryCache: true,
        clearMemoryCacheIfFailed: true,
        loadStateChanged: _onLoadStateChanged,
      );
    }
    return ExtendedImage.network(
      (!url.startsWith('http://') && !url.startsWith('https://'))
          ? staticFileBaseUrl + (url.startsWith('/') ? url : '/' + url)
          : url,
      filterQuality: filterQuality,
      fit: fit,
      width: width,
      height: height,
      enableLoadState: true,
      enableMemoryCache: true,
      clearMemoryCacheIfFailed: true,
      cache: !kIsWeb,
      loadStateChanged: _onLoadStateChanged,
    );
  }

  Widget _onLoadStateChanged(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.completed:
        if (onComplete != null) {
          onComplete();
        }
        return null;
      case LoadState.loading:
        return placeholder;
      case LoadState.failed:
        if (onFailed != null) {
          return onFailed() ?? placeholder;
        }
        return placeholder;
      default:
        return null;
    }
  }
}
