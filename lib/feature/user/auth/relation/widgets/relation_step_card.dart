import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';

class RelationStepCard extends StatelessWidget {
  const RelationStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.child,
    this.isCompleted = false,
    this.showLine = true,
    this.onEdit,
  });

  final String stepNumber;
  final String title;
  final String subtitle;
  final Widget child;
  final bool isCompleted;
  final bool showLine;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (showLine)
          Positioned(
            right: -1.w,
            top: 20.h + 30.r,
            bottom: -20.h,
            child: Container(
              width: 2.w,
              color: AppColors.accentGold600.withOpacity(0.5),
            ),
          ),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isCompleted && onEdit != null)
                    TextButton(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        AppTexts.relationEdit,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.accentGold600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.neutral500,
                ),
              ),
              SizedBox(height: 20.h),
              child,
            ],
          ),
        ),
        Positioned(
          right: -15.w,
          top: 20.h,
          child: Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.primaryColor700 : AppColors.white,
              border: Border.all(
                color: isCompleted ? AppColors.primaryColor700 : AppColors.accentGold600,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, size: 18.sp, color: AppColors.white)
                  : Text(
                      stepNumber,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGold600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

