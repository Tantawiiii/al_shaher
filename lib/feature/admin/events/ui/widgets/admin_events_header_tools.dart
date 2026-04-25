import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminEventsHeaderTools extends StatelessWidget {
  const AdminEventsHeaderTools({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleSort,
    required this.visibleCount,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleSort;
  final int visibleCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppTexts.treeSearchHint,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.neutral500,
                  size: 22.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Bounce(
                onTap: onToggleSort,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.neutral200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_vert_rounded,
                        size: 16.sp,
                        color: AppColors.neutral600,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'ترتيب',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${AppTexts.events} ( $visibleCount )',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
