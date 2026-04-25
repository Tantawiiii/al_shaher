import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/app_colors.dart';

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.primaryColor900.withOpacity(0.35),
            highlightColor: AppColors.white.withOpacity(0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 220.h + 52.r,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 220.h,
                        width: double.infinity,
                        color: AppColors.primaryColor100,
                      ),
                      Container(
                        width: 104.r,
                        height: 104.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neutral200,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
                  child: Column(
                    children: [
                      Container(
                        height: 20.h,
                        width: 160.w,
                        margin: EdgeInsets.symmetric(horizontal: 40.w),
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        height: 32.h,
                        width: 100.w,
                        margin: EdgeInsets.symmetric(horizontal: 80.w),
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: List.generate(
                5,
                (i) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Shimmer.fromColors(
                    baseColor: AppColors.primaryColor900.withOpacity(0.35),
                    highlightColor: AppColors.white.withOpacity(0.4),
                    child: Container(
                      height: 72.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
