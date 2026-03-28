import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/widgets/app_bounce_button.dart';
import 'order_details_screen.dart';

class RelationSuccessScreen extends StatelessWidget {
  const RelationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor900,
      body: Center(
        child: Container(
          width: 0.85.sw,
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon/Image
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: AppColors.accentGold400.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 50.sp,
                    color: AppColors.accentGold600,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppTexts.relationSuccessTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor900,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppTexts.relationSuccessSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.neutral500,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              AppBounceButton.elevated(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderDetailsScreen()),
                  );
                },
                label: AppTexts.relationSuccessOk,
                backgroundColor: AppColors.primaryColor700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
