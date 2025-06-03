import 'dart:ui';
import 'package:fit_rpg/Services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
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
                  width: 360.w,
                  height: 360.h,
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
                width: 165.w, // hitbox size
                height: 275.h,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Holds one icon’s “design-time” rectangle within a 1000×1500 canvas:
class IconInfo {
  final String assetPath;
  final VoidCallback onTap;
  final int ulx, uly;  // upper-left corner in design pixels
  final int brx, bry;  // bottom-right corner in design pixels

  const IconInfo({
    required this.assetPath,
    required this.onTap,
    required this.ulx,
    required this.uly,
    required this.brx,
    required this.bry,
  });
}

/// A widget that draws a 1000×1500 background (BoxFit.contain) and then
/// overlays each IconInfo at the correct scaled & offset position.
class ResponsiveIconsOverBackground extends StatelessWidget {
  /// Path to your 1000×1500 PNG (e.g. 'assets/images/Hub_BG.png').
  final String backgroundAsset;

  /// The exact “design-time” width and height of that PNG, in pixels.
  final double bgDesignWidth;
  final double bgDesignHeight;

  /// List of icons to overlay. Each IconInfo knows its (ulx, uly, brx, bry).
  final List<IconInfo> icons;

  const ResponsiveIconsOverBackground({
    Key? key,
    required this.backgroundAsset,
    this.bgDesignWidth = 1000,
    this.bgDesignHeight = 1500,
    required this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1) The parent’s size:
        final double W = constraints.maxWidth;
        final double H = constraints.maxHeight;

        // 2) Compute “scale” so the entire image fits (BoxFit.contain):
        final double rawScale = H / bgDesignHeight;
        final double scale = rawScale.clamp(0.0, 1.0);

        // 3) Compute the drawn size of the background:
        final double imgDrawnW = bgDesignWidth * scale;
        final double imgDrawnH = bgDesignHeight * scale;

        // 4) Center the image inside the parent (BoxFit.fill always centers):
        final double offsetX = (W - imgDrawnW) / 2;
        final double offsetY = (H - imgDrawnH) / 2;

        // Build a Stack: first child is the background, second is all icons.
        return Stack(
          children: [
            // A) Background positioned & sized exactly to fill (cover) the parent:
            Positioned(
              left: offsetX,
              top:  offsetY,
              width:  imgDrawnW,
              height: imgDrawnH,
              child: Image.asset(
                backgroundAsset,
                width: bgDesignWidth,
                height: bgDesignHeight,
                fit: BoxFit.fill, 
                // We already sized the container to imgDrawnW × imgDrawnH,
                // so BoxFit.fill simply stretches the 1000×1500 image to that box.
              ),
            ),

            // Overlay each icon at (offsetX + designX×scale, offsetY + designY×scale)
            ...icons.map((icon) {
              // Actual design-time width/height (in our 1000×1500 PNG):
              final double iconDesignW = (icon.brx - icon.ulx).toDouble();
              final double iconDesignH = (icon.bry - icon.uly).toDouble();

              // Scaled and offset positions:
              final double leftPx = offsetX + icon.ulx * scale;
              final double topPx = offsetY + icon.uly * scale;
              final double widthPx = iconDesignW * scale;
              final double heightPx = iconDesignH * scale;

              return Positioned(
                left: leftPx,
                top: topPx,
                width: widthPx,
                height: heightPx,
                child: AnimatedIconButton(
                  assetPath: icon.assetPath,
                  onTap: icon.onTap,
                  animationDuration: 100, // 100ms for quick response
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

/// A small icon button that animates on hover (desktop/web) and on tap press.
/// Just supply the asset path and onTap callback.
class AnimatedIconButton extends StatefulWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double animationDuration; // milliseconds

  const AnimatedIconButton({
    Key? key,
    required this.assetPath,
    required this.onTap,
    this.animationDuration = 100,
  }) : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  /// 1.0 = idle, 1.05 = hover, 0.9 = pressed
  double _scale = 1.0;

  void _onEnter(PointerEvent details) {
    // only hover‐scale on desktop/web
    setState(() => _scale = 1.05);
  }

  void _onExit(PointerEvent details) {
    setState(() => _scale = 1.0);
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 1.05);
  }

  void _onTapUp(TapUpDetails details) {
    // after press ends, bounce back to hover (if still hovered) or idle
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in MouseRegion to get hover events on web/desktop
    return MouseRegion(
      onEnter: (event) => _onEnter(event),
      onExit: (event) => _onExit(event),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: Duration(milliseconds: widget.animationDuration.toInt()),
          curve: Curves.easeOut,
          child: Image.asset(
            widget.assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}