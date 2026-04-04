import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData? icon;
  final Color? iconColor;
  final String? imageUrl;

  const NotificationItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    this.icon,
    this.iconColor,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              time,
              style: TextStyle(
                color: AppColors.neutral400,
                fontSize: 12.sp,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.neutral900,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                6.verticalSpace,
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.neutral500,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          12.horizontalSpace,

          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                imageUrl!,
                width: 45.w,
                height: 45.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 45.w,
                  height: 45.h,
                  color: AppColors.neutral200,
                  child: Icon(Icons.broken_image,
                      color: AppColors.neutral400, size: 20.sp),
                ),
              ),
            )
          else if (icon != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primaryColor500,
                size: 26.sp,
              ),
            ),
        ],
      ),
    );
  }
}
