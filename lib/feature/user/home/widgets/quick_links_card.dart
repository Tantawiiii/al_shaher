import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class QuickLinksCard extends StatelessWidget {
  const QuickLinksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
            title: 'شجرة العائلة',
            onTap: () {},
          ),
          _QuickLinkItem(
            icon: Icons.calendar_month_outlined,
            title: 'المناسبات',
            onTap: () {},
          ),
          _QuickLinkItem(
            icon: Icons.article_outlined,
            title: 'الاخبار',
            onTap: () {},
          ),
          _QuickLinkItem(
            icon: Icons.edit_document,
            title: 'تقديم طلب',
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}
