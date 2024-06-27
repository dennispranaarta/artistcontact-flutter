
import 'package:flutter/material.dart';

class AssetImageRounded extends StatelessWidget {
  final String imagePath;

  const AssetImageRounded({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ));
  }
}
