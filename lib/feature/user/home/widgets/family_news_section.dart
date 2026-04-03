import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class FamilyNewsSection extends StatelessWidget {
  const FamilyNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            AppTexts.familyNews,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 240.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              return _NewsCard(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final int index;
  const _NewsCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: (){},
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral900.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: index.isEven ? AppColors.accentGold400 : AppColors.primaryColor300,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.white,
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عنوان الاخبار والفعاليات هنا',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'نص تجريبي للخبر',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
