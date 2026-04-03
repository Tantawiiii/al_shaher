import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';

class SuggestionItem extends StatelessWidget {
  const SuggestionItem({
    super.key,
    required this.name,
    required this.year,
    required this.onTap,
    this.selected = false,
  });

  final String name;
  final String year;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor100.withOpacity(0.5)
              : null,
          borderRadius: BorderRadius.circular(8.r),
          border: Border(
            bottom: BorderSide(color: AppColors.neutral100),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTexts.relationDidYouMean,
              style: TextStyle(fontSize: 10.sp, color: AppColors.neutral400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor800,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  year,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

