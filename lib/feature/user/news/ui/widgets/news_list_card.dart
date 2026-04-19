

import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../data/news_model.dart';

class NewsListCard extends StatelessWidget {
  const NewsListCard({required this.news});

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.newsDetails,
        arguments: news.id,
      ),
      child: Container(
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
            _buildGalleryThumbnails(),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.createdAt != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13.sp,
                          color: AppColors.neutral400,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          news.createdAt!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 6.h),
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (news.summary != null && news.summary!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      news.summary!,
                      style: TextStyle(
                        fontSize: 11.sp,
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

  Widget _buildGalleryThumbnails() {
    if (news.gallery.isEmpty) {
      return _placeholderThumb();
    }
    final img = news.gallery.first;
    final url = img.resolvedImageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        width: 65.w,
        height: 65.w,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: 65.w,
          height: 65.w,
          color: AppColors.neutral200,
        ),
        errorWidget: (_, __, ___) => Container(
          width: 65.w,
          height: 65.w,
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

  Widget _placeholderThumb() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 65.w,
        height: 65.w,
        color: AppColors.neutral200,
        child: Icon(
          Icons.image_outlined,
          size: 24.sp,
          color: AppColors.neutral400,
        ),
      ),
    );
  }
}