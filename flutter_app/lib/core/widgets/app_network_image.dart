import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/product_placeholder.png',
          width: width,
          height: height,
          fit: fit,
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return Container(
          width: width,
          height: height,
          color: const Color(0xFFF1F5F9),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );

    if (borderRadius == null) {
      return image;
    }
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
