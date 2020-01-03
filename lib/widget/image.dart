import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat/service/base.dart';

class UImage extends StatelessWidget {
  const UImage(
      {Key key,
      this.placeholder,
      @required this.size,
      @required String url,
      this.filterQuality = FilterQuality.low,
      this.fit = BoxFit.fill})
      : assert(size != null),
        url = url ?? '',
        super(key: key);

  final PlaceholderWidgetBuilder placeholder;
  final Size size;
  final String url;
  final FilterQuality filterQuality;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    const String assetUrlStart = 'asset://';
    if (url.startsWith(assetUrlStart)) {
      return Image.asset(
        url.substring(assetUrlStart.length),
        filterQuality: filterQuality,
        fit: fit,
        width: size.width,
        height: size.height,
      );
    }
    return CachedNetworkImage(
      placeholder: placeholder,
      imageUrl: (!url.startsWith('http://') && !url.startsWith('https://'))
          ? staticFileBaseUrl + (url.startsWith('/') ? url : '/' + url)
          : url,
      width: size.width,
      height: size.height,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      filterQuality: filterQuality,
      fit: fit,
    );
  }
}
