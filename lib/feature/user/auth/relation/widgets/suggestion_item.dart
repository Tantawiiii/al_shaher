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
  });

  final String name;
  final String year;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.neutral100)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppTexts.relationDidYouMean,
              style: TextStyle(fontSize: 10.sp, color: AppColors.neutral400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  year,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
                ),
                SizedBox(width: 8.w),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

