import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/core/routing/app_routes.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class QuickLinksCard extends StatelessWidget {
  const QuickLinksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickLinkItem(
            icon: Icons.people_outline_rounded,
            title: AppTexts.familyTree,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.familyTree);
            },
          ),
          _QuickLinkItem(
            icon: Icons.calendar_month_outlined,
            title: AppTexts.events,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.events);
            },
          ),
          _QuickLinkItem(
            icon: Icons.article_outlined,
            title: AppTexts.news,
            onTap: () {},
          ),
          _QuickLinkItem(
            icon: Icons.edit_document,
            title: AppTexts.orderRequest,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _QuickLinkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickLinkItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor700,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}
