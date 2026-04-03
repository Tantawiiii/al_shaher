import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_texts.dart';
import '../../core/routing/app_routes.dart';
import '../../core/widgets/app_bounce_button.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset(
            AppAssets.loginHeader,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          SizedBox(height: 20.h,),
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

                  AppBounceButton.elevated(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                    label: AppTexts.loginNewAccount,
                  ),
                  SizedBox(height: 16.h),
                  AppBounceButton.outlined(
                    onPressed:  () => Navigator.of(context).pushNamed(AppRoutes.login),
                    label: AppTexts.loginSignIn,
                  ),
                  const Spacer(),
                  Text(
                    AppTexts.loginTermsAgreement,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
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
