import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with Logo
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.loginHeader,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 80.h,
                child: Image.asset(
                  AppAssets.appLogoImg,
                  width: 150.w,
                ),
              ),
            ],
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTexts.loginWelcomeTitle,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor900,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        AppTexts.loginWelcomeEmoji,
                        style: TextStyle(fontSize: 24.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppTexts.loginWelcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.neutral600,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  
                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppTexts.loginNewAccount,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryColor400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: Text(
                        AppTexts.loginSignIn,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.primaryColor600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Terms text
                  Text(
                    AppTexts.loginTermsAgreement,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.neutral400,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
