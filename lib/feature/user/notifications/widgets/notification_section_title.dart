import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class NotificationSectionTitle extends StatelessWidget {
  final String title;
  const NotificationSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.neutral400,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.neutral200.withOpacity(0.5),
          ),
        ),


      ],
    );
  }
}
