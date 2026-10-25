import 'package:flutter/widgets.dart';

/// Decodes an asset at the size it is drawn, never at full resolution.
class SizedAssetImage extends StatelessWidget {
  const SizedAssetImage(this.asset, {required this.size, super.key});

  final String asset;
  final double size;

  static ImageProvider<Object> provider(
    String asset,
    double size,
    double dpr,
  ) => ResizeImage(AssetImage(asset), width: (size * dpr).round());

  @override
  Widget build(BuildContext context) {
    final double dpr = MediaQuery.devicePixelRatioOf(context);
    return Image(
      image: provider(asset, size, dpr),
      width: size,
      height: size,
      fit: BoxFit.contain,
      gaplessPlayback: true,
    );
  }
}
