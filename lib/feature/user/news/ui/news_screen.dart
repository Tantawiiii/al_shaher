import 'package:al_shaher/feature/user/news/ui/widgets/news_list_card.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/routing/app_routes.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../data/news_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.addNews).then((_) {
            context.read<NewsCubit>().loadNews();
          }),
          backgroundColor: AppColors.primaryColor600,
          child: const Icon(Icons.add, color: AppColors.white),
        ),
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case NewsStatus.initial:
                    case NewsStatus.loading:
                      return const _NewsScreenShimmer();
                    case NewsStatus.error:
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.errorMessage ?? 'حدث خطأ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.neutral500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              Bounce(
                                onTap: () =>
                                    context.read<NewsCubit>().loadNews(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor600,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    'إعادة المحاولة',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    case NewsStatus.loaded:
                      if (state.newsList.isEmpty) {
                        return Center(
                          child: Text(
                            AppTexts.newsEmpty,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.neutral400,
                            ),
                          ),
                        );
                      }
                      return _buildLoadedContent(state.newsList);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor700, AppColors.primaryColor600],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor900.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Bounce(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_outlined,
                  color: AppColors.white,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  AppTexts.registerBack,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            AppTexts.newsTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          SizedBox(width: 60.w),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(List<NewsModel> newsList) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _buildCarousel(newsList),
          SizedBox(height: 12.h),
          _buildDots(newsList.length),
          // SizedBox(height: 12.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20.w),
          //   child: Text(
          //     newsList[_currentPage.clamp(0, newsList.length - 1)].title,
          //     style: TextStyle(
          //       fontSize: 16.sp,
          //       fontWeight: FontWeight.bold,
          //       color: AppColors.neutral900,
          //       height: 1.6,
          //     ),
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
          SizedBox(height: 20.h),
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: newsList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) =>
                NewsListCard(news: newsList[index]),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<NewsModel> newsList) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 200.h,
        child: PageView.builder(
          controller: _pageController,
          itemCount: newsList.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            final news = newsList[index];
            return Bounce(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.newsDetails,
                arguments: news.id,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral900.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: news.firstImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: news.firstImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (_, __) => Container(
                            color: AppColors.neutral200,
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: AppColors.neutral400,
                                size: 40.sp,
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.neutral200,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.neutral400,
                                size: 40.sp,
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: _currentPage == index ? 10.w : 8.w,
          height: _currentPage == index ? 10.w : 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? AppColors.primaryColor600
                : AppColors.neutral300,
          ),
        ),
      ),
    );
  }
}



class _NewsScreenShimmer extends StatelessWidget {
  const _NewsScreenShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Carousel shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryColor900.withOpacity(0.35),
              highlightColor: AppColors.white.withOpacity(0.4),
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Dots shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Shimmer.fromColors(
                baseColor: AppColors.primaryColor900.withOpacity(0.35),
                highlightColor: AppColors.white.withOpacity(0.4),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neutral200,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Title shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryColor900.withOpacity(0.35),
              highlightColor: AppColors.white.withOpacity(0.4),
              child: Container(
                height: 18.h,
                width: 0.7.sw,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // List shimmer
          ...List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: 12.h,
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.primaryColor900.withOpacity(0.35),
                highlightColor: AppColors.white.withOpacity(0.4),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 65.w,
                        height: 65.w,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        width: 65.w,
                        height: 65.w,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: AppColors.neutral200,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 12.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.neutral200,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              height: 12.h,
                              width: 0.4.sw,
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
          ),
        ],
      ),
    );
  }
}
