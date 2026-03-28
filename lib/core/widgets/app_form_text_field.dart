import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

/// Rounded filled text field for auth/forms: RTL-friendly, optional [leadingIcon]
/// (visual right in Arabic), optional [trailing] (visual left), optional helper below.
class AppFormTextField extends StatelessWidget {
  const AppFormTextField({
    super.key,
    this.controller,
    this.hintText,
    this.leadingIcon,
    this.trailing,
    this.helperText,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.focusedBorderColor,
    this.unfocusedBorderColor,
    this.borderWidth,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? leadingIcon;
  final Widget? trailing;
  final String? helperText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Color? focusedBorderColor;
  final Color? unfocusedBorderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 30.r;
    final fill = fillColor ?? AppColors.neutral100;
    final unfocused = unfocusedBorderColor ?? Colors.transparent;
    final focused = focusedBorderColor ?? AppColors.primaryColor600;
    final bw = borderWidth ?? 1.5;

    final pad = contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);

    final hintS = hintStyle ??
        TextStyle(
          fontSize: 15.sp,
          color: AppColors.neutral400,
        );
    final textS = textStyle ??
        TextStyle(
          fontSize: 15.sp,
          color: AppColors.neutral900,
        );

    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      textAlign: TextAlign.right,
      style: textS,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintS,
        filled: true,
        fillColor: fill,
        contentPadding: pad,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: unfocused, width: unfocused == Colors.transparent ? 0 : bw),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: focused, width: bw),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        prefixIcon: leadingIcon != null
            ? Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: AppColors.neutral400,
                    size: 22.sp,
                  ),
                  child: leadingIcon!,
                ),
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
        suffixIcon: trailing != null
            ? Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: trailing,
              )
            : null,
        suffixIconConstraints: BoxConstraints(minHeight: 48.h),
      ),
    );

    if (helperText == null || helperText!.isEmpty) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        field,
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: Text(
            helperText!,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.neutral400,
            ),
          ),
        ),
      ],
    );
  }
}
