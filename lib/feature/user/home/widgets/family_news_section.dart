import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../user/news/cubit/news_cubit.dart';
import '../../../user/news/cubit/news_state.dart';
import '../../../user/news/data/news_model.dart';

class FamilyNewsSection extends StatelessWidget {
  const FamilyNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTexts.familyNews,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                  if (state.status == NewsStatus.loaded &&
                      state.newsList.isNotEmpty)
                    Bounce(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.news),
                      child: Text(
                        AppTexts.seeAll,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildContent(context, state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, NewsState state) {
    switch (state.status) {
      case NewsStatus.initial:
      case NewsStatus.loading:
        return const _NewsSectionShimmer();
      case NewsStatus.error:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Center(
            child: Text(
              state.errorMessage ?? 'حدث خطأ',
              style: TextStyle(fontSize: 13.sp, color: AppColors.neutral400),
            ),
          ),
        );
      case NewsStatus.loaded:
        if (state.newsList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Center(
              child: Text(
                AppTexts.newsEmpty,
                style: TextStyle(fontSize: 13.sp, color: AppColors.neutral400),
              ),
            ),
          );
        }
        final displayNews = state.newsList.take(5).toList();
        return SizedBox(
          height: 240.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: displayNews.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) =>
                _NewsCard(news: displayNews[index]),
          ),
        );
    }
  }
}

class _NewsSectionShimmer extends StatelessWidget {
  const _NewsSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemBuilder: (_, index) => Shimmer.fromColors(
          baseColor: AppColors.primaryColor900.withOpacity(0.35),
          highlightColor: AppColors.white.withOpacity(0.4),
          child: Container(
            width: 200.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.r)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 10.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news});

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
              child: ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
                child: news.firstImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: news.firstImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.neutral200,
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.neutral400,
                              size: 32.sp,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.neutral200,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.neutral400,
                              size: 32.sp,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.primaryColor300,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.white,
                            size: 40.sp,
                          ),
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
                    news.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                  if (news.summary != null &&
                      news.summary!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      news.summary!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.neutral500,
                      ),
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
}
