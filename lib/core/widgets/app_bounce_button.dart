import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

/// Filled (elevated-style) or outlined container button with [Bounce] feedback.
enum AppBounceButtonVariant {
  elevated,
  outlined,
}

class AppBounceButton extends StatelessWidget {
  const AppBounceButton({
    super.key,
    required this.variant,
    this.onPressed,
    this.child,
    this.label,
    this.labelStyle,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.padding,
    this.alignment = Alignment.center,
    this.boxShadow,
    this.bounceDuration,
    this.bounceTapDelay,
    this.bounceScaleFactor = 0.97,
    this.bounceTilt = false,
  }) : assert(
          child != null || label != null,
          'Provide child or label',
        );

  /// Filled container — defaults match primary elevated style.
  AppBounceButton.elevated({
    Key? key,
    VoidCallback? onPressed,
    Widget? child,
    String? label,
    TextStyle? labelStyle,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment = Alignment.center,
    List<BoxShadow>? boxShadow,
    Duration? bounceDuration,
    Duration? bounceTapDelay,
    double bounceScaleFactor = 0.97,
    bool bounceTilt = false,
  }) : this(
          key: key,
          variant: AppBounceButtonVariant.elevated,
          onPressed: onPressed,
          child: child,
          label: label,
          labelStyle: labelStyle,
          width: width,
          height: height,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          borderRadius: borderRadius,
          padding: padding,
          alignment: alignment,
          boxShadow: boxShadow,
          bounceDuration: bounceDuration,
          bounceTapDelay: bounceTapDelay,
          bounceScaleFactor: bounceScaleFactor,
          bounceTilt: bounceTilt,
        );

  /// Outlined container — defaults match primary outline style.
  AppBounceButton.outlined({
    Key? key,
    VoidCallback? onPressed,
    Widget? child,
    String? label,
    TextStyle? labelStyle,
    double? width,
    double? height,
    Color? borderColor,
    double borderWidth = 1,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment = Alignment.center,
    Duration? bounceDuration,
    Duration? bounceTapDelay,
    double bounceScaleFactor = 0.97,
    bool bounceTilt = false,
  }) : this(
          key: key,
          variant: AppBounceButtonVariant.outlined,
          onPressed: onPressed,
          child: child,
          label: label,
          labelStyle: labelStyle,
          width: width,
          height: height,
          borderColor: borderColor,
          borderWidth: borderWidth,
          foregroundColor: foregroundColor,
          borderRadius: borderRadius,
          padding: padding,
          alignment: alignment,
          bounceDuration: bounceDuration,
          bounceTapDelay: bounceTapDelay,
          bounceScaleFactor: bounceScaleFactor,
          bounceTilt: bounceTilt,
        );

  final AppBounceButtonVariant variant;
  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final TextStyle? labelStyle;

  final double? width;
  final double? height;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;

  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;


  final List<BoxShadow>? boxShadow;

  final Duration? bounceDuration;
  final Duration? bounceTapDelay;
  final double bounceScaleFactor;
  final bool bounceTilt;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final radius = borderRadius ??
        (variant == AppBounceButtonVariant.elevated ? 28.r : 28.r);
    final h = height ?? 56.h;
    final w = width ?? double.infinity;
    final pad = padding ?? EdgeInsets.symmetric(horizontal: 16.w);

    final Color fg = foregroundColor ??
        (variant == AppBounceButtonVariant.elevated
            ? AppColors.white
            : AppColors.primaryColor600);

    final TextStyle effectiveLabelStyle = labelStyle ??
        TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: fg,
        );

    final Widget content = child ??
        Text(
          label!,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: effectiveLabelStyle,
        );

    late final Widget surface;
    switch (variant) {
      case AppBounceButtonVariant.elevated:
        surface = Container(
          width: w,
          height: h,
          alignment: alignment,
          padding: pad,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.primaryColor700,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: boxShadow ?? const <BoxShadow>[],
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: 22.sp),
            child: DefaultTextStyle.merge(
              style: effectiveLabelStyle,
              child: content,
            ),
          ),
        );
        break;
      case AppBounceButtonVariant.outlined:
        surface = Container(
          width: w,
          height: h,
          alignment: alignment,
          padding: pad,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? AppColors.primaryColor400,
              width: borderWidth,
            ),
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: 22.sp),
            child: DefaultTextStyle.merge(
              style: effectiveLabelStyle,
              child: content,
            ),
          ),
        );
        break;
    }

    final Widget tappable = Opacity(
      opacity: enabled ? 1 : 0.45,
      child: surface,
    );

    if (!enabled) {
      return tappable;
    }

    return Bounce(
      onTap: onPressed,
      scaleFactor: bounceScaleFactor,
      tilt: bounceTilt,
      child: tappable,
    );
  }
}
