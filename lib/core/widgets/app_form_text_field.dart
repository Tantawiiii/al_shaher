import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

/// Rounded filled text field for auth/forms: RTL-friendly, optional [leadingIcon]
/// (visual right in Arabic), optional [trailing] (visual left), optional helper below.
///
/// When [showPasswordToggle] is true and [obscureText] is true, a suffix eye icon
/// toggles masking without changing the controller.
class AppFormTextField extends StatefulWidget {
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
    this.showPasswordToggle = false,
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
  final bool showPasswordToggle;
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
  State<AppFormTextField> createState() => _AppFormTextFieldState();
}

class _AppFormTextFieldState extends State<AppFormTextField> {
  bool _passwordHidden = true;

  @override
  void didUpdateWidget(AppFormTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.obscureText && oldWidget.obscureText) {
      _passwordHidden = true;
    }
  }

  bool get _effectiveObscure {
    if (!widget.showPasswordToggle || !widget.obscureText) {
      return widget.obscureText;
    }
    return _passwordHidden;
  }

  Widget? _buildSuffixIcon() {
    final hasToggle = widget.showPasswordToggle && widget.obscureText;
    if (!hasToggle && widget.trailing == null) return null;

    final toggle = hasToggle
        ? IconButton(
            onPressed: () => setState(() => _passwordHidden = !_passwordHidden),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.neutral400,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Icon(
              _passwordHidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 22.sp,
            ),
            tooltip: _passwordHidden ? 'Show password' : 'Hide password',
          )
        : null;

    if (widget.trailing == null) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 4.w),
        child: toggle,
      );
    }
    if (toggle == null) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w),
        child: widget.trailing,
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [widget.trailing!, toggle],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final radius = w.borderRadius ?? 30.r;
    final fill = w.fillColor ?? AppColors.neutral100;
    final unfocused = w.unfocusedBorderColor ?? Colors.transparent;
    final focused = w.focusedBorderColor ?? AppColors.primaryColor600;
    final bw = w.borderWidth ?? 1.5;

    final pad =
        w.contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);

    final hintS =
        w.hintStyle ?? TextStyle(fontSize: 15.sp, color: AppColors.neutral400);
    final textS =
        w.textStyle ?? TextStyle(fontSize: 15.sp, color: AppColors.neutral900);

    final suffix = _buildSuffixIcon();

    final field = TextField(
      controller: w.controller,
      focusNode: w.focusNode,
      keyboardType: w.keyboardType,
      textInputAction: w.textInputAction,
      obscureText: _effectiveObscure,
      enabled: w.enabled,
      onChanged: w.onChanged,
      inputFormatters: w.inputFormatters,
      maxLines: w.maxLines,
      readOnly: w.readOnly,
      onTap: w.onTap,
      textAlign: TextAlign.right,
      style: textS,
      decoration: InputDecoration(
        hintText: w.hintText,
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
          borderSide: BorderSide(
            color: unfocused,
            width: unfocused == Colors.transparent ? 0 : bw,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: focused, width: bw),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        prefixIcon: w.leadingIcon != null
            ? Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                child: IconTheme.merge(
                  data: IconThemeData(color: AppColors.neutral400, size: 22.sp),
                  child: w.leadingIcon!,
                ),
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
        suffixIcon: suffix,
        suffixIconConstraints: BoxConstraints(minHeight: 48.h),
      ),
    );

    if (w.helperText == null || w.helperText!.isEmpty) {
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
            w.helperText!,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.sp, color: AppColors.neutral400),
          ),
        ),
      ],
    );
  }
}
