import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat/service/base.dart';

class CachedImage extends StatelessWidget {
  final PlaceholderWidgetBuilder placeholder;
  final Size size;
  final String url;
  final FilterQuality filterQuality;
  final BoxFit fit;

  CachedImage(
      {this.placeholder,
      @required this.size,
      @required this.url,
      this.filterQuality = FilterQuality.low,
      this.fit = BoxFit.fill})
      : assert(size != null);

  @override
  Widget build(BuildContext context) {
    String imageUrl = url ?? "";
    if (!imageUrl.startsWith("http")) {
      imageUrl = Service.staticFileUrl +
          (imageUrl.startsWith("/") ? imageUrl : "/" + imageUrl);
    }
    return CachedNetworkImage(
      placeholder: placeholder,
      imageUrl: imageUrl,
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
