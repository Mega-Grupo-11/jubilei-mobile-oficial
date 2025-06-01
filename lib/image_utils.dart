import 'package:flutter/material.dart';

class ImageUtils {
  // Retorna uma imagem com tamanho padrão
  static Widget standardImage(
    BuildContext context,
    String imagePath, {
    double widthFactor = 0.8,
    double aspectRatio = 1.0,
    BoxFit fit = BoxFit.contain,
    Color? backgroundColor,
    double borderRadius = 0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth * widthFactor;
    final height = width / aspectRatio;

    Widget image = Image.asset(
      imagePath,
      fit: fit,
      height: height,
      width: width,
      errorBuilder:
          (context, error, stackTrace) => SizedBox(
            height: height,
            width: width,
            child: Icon(
              Icons.broken_image,
              size: width * 0.3,
              color: Colors.grey[400],
            ),
          ),
    );

    if (backgroundColor != null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(width * 0.05),
        child: image,
      );
    }

    return image;
  }
}
