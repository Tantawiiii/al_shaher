import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'المضافون حديثا',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 60.r,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: 6, // 5 avatars + 1 upload button
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              if (index == 5) {
                return _buildAddButton();
              }
              // Placeholder for user avatar, using alternating colors for now
              return Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index.isEven
                      ? AppColors.neutral300
                      : AppColors.primaryColor200,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral900.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.white,
                    size: 30.sp,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () {},
      customBorder: const CircleBorder(),
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor700,
        ),
        child: Icon(
          Icons.ios_share_rounded, // Best match for the upload/share icon
          color: AppColors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}
