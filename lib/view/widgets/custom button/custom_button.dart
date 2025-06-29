
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ Made nullable
  final bool useGradient;
  final Color? singleColor;
  final Gradient? gradient;
  final double borderRadius;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed, // ✅ Optional now
    this.useGradient = true,
    this.singleColor,
    this.gradient,
    this.borderRadius = 12,
    this.width,
    this.height = 50,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultGradient = const LinearGradient(
      colors: [Color(0xFFA372C3), Color(0xFFB59EF0)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );

    final bgDecoration = BoxDecoration(
      gradient: useGradient ? (gradient ?? defaultGradient) : null,
      color: useGradient ? null : (singleColor ?? Colors.blue),
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0, // ✅ Disable feel when null
        child: Container(
          width: width ?? double.infinity,
          height: height,
          decoration: bgDecoration,
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
