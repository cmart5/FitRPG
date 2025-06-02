import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedText extends StatelessWidget {
  final Widget child;
  final double sigmaX, sigmaY;
  final Color color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const FrostedText({
    Key? key,
    required this.child,
    this.sigmaX = 6,
    this.sigmaY = 6,
    this.color = Colors.white,
    this.borderRadius,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        //Blur effect
        child: BackdropFilter(
          filter: ImageFilter.blur( // Blur strength
            sigmaX: sigmaX,
            sigmaY: sigmaY,
          ),
          child: Container(
            padding: padding,
            color: color,
            child: child,
          )
        ),
      ),
    );
  }
}