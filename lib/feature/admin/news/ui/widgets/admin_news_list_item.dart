import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/feature/user/news/data/news_model.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminNewsListItem extends StatelessWidget {
  const AdminNewsListItem({
    super.key,
    required this.news,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final NewsModel news;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral900.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildMenu(),
            SizedBox(width: 8.w),
            _buildImage(),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.createdAt != null)
                    Text(
                      news.createdAt!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.neutral500,
                      ),
                    ),
                  SizedBox(height: 4.h),
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (news.summary != null && news.summary!.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      news.summary!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.neutral500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, color: AppColors.neutral500, size: 20.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
          return;
        }
        if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.primaryColor600, size: 18.sp),
              SizedBox(width: 8.w),
              Text(AppTexts.newsEdit),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: AppColors.error600, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                AppTexts.newsDelete,
                style: const TextStyle(color: AppColors.error600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (news.firstImageUrl == null) {
      return Container(
        width: 68.w,
        height: 68.w,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          Icons.image_outlined,
          size: 24.sp,
          color: AppColors.neutral400,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CachedNetworkImage(
        imageUrl: news.firstImageUrl!,
        width: 68.w,
        height: 68.w,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: 68.w,
          height: 68.w,
          color: AppColors.neutral200,
        ),
        errorWidget: (_, __, ___) => Container(
          width: 68.w,
          height: 68.w,
          color: AppColors.neutral200,
          child: Icon(
            Icons.broken_image_outlined,
            size: 20.sp,
            color: AppColors.neutral400,
          ),
        ),
      ),
    );
  }
}
