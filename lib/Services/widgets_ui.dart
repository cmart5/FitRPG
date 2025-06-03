import 'dart:ui';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:flutter/material.dart';

class FrostedText extends StatelessWidget {
  final Widget child;
  final double sigmaX, sigmaY;
  final Color color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const FrostedText({
    super.key,
    required this.child,
    this.sigmaX = 6,
    this.sigmaY = 6,
    this.color = Colors.white,
    this.borderRadius,
    this.padding = const EdgeInsets.all(8),
  });

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


class InteractiveIcon extends StatefulWidget {
  final String label;
  final String assetPath;
  final VoidCallback onTap;

  const InteractiveIcon({
    required this.label,
    required this.assetPath,
    required this.onTap,
    super.key,
  });

  @override
  State<InteractiveIcon> createState() => InteractiveIconState();
}

class InteractiveIconState extends State<InteractiveIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Animate the PNG itself
            AnimatedScale(
              scale: _isPressed ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: IgnorePointer( // Ignore taps while pressed
                child: Image.asset(
                  widget.assetPath,
                  width: 360,
                  height: 360,
                ),
              ),
            ),
            // Transparent touch hitbox
            GestureDetector(
              onTapDown: (_) {
                setState(() => _isPressed = true);
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                AudioService().playSFX('touch.wav');
                Feedback.forTap(context);
                widget.onTap();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
              },
              child: Container(
                width: 165, // hitbox size
                height: 275,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}