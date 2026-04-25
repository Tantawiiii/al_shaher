import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../cubit/news_cubit.dart';
import '../../data/news_model.dart';

class NewsListCard extends StatelessWidget {
  const NewsListCard({
    required this.news,
    this.canManage = false,
  });

  final NewsModel news;
  final bool canManage;

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
            if (canManage) ...[
              _buildPopupMenu(context),
              SizedBox(width: 8.w),
            ],
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

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, color: AppColors.neutral500, size: 20.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.pushNamed(context, AppRoutes.addNews, arguments: news)
              .then((_) => context.read<NewsCubit>().loadNews());
          return;
        }
        if (value == 'delete') {
          _confirmDelete(context);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.primaryColor600, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                AppTexts.newsEdit,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral900,
                ),
              ),
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
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            AppTexts.newsDeleteConfirm,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppTexts.newsDeleteMessage,
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                AppTexts.eventsCancel,
                style: TextStyle(color: AppColors.neutral500, fontSize: 14.sp),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                context.read<NewsCubit>().deleteNews(news.id);
                Fluttertoast.showToast(
                  msg: AppTexts.newsDeleted,
                  backgroundColor: AppColors.success600,
                );
              },
              child: Text(
                AppTexts.newsDelete,
                style: TextStyle(color: AppColors.error600, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}