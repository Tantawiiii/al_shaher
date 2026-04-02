import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class SelectionItem extends StatelessWidget {
  const SelectionItem({
    super.key,
    required this.label,
    required this.onTap,
    this.isDropdown = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDropdown;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral200),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              isDropdown ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_down,
              color: AppColors.neutral400,
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.neutral700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

