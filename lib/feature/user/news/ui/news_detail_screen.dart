import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../data/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late final bool _isAdmin;

  @override
  void initState() {
    super.initState();
    _isAdmin = sl<AuthLocalStorage>().getAuthType() == 'admin';
    context.read<NewsCubit>().loadNewsDetails(widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        body: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            switch (state.detailStatus) {
              case NewsDetailStatus.initial:
              case NewsDetailStatus.loading:
                return const _DetailShimmer();
              case NewsDetailStatus.error:
                return _buildError(state.detailError);
              case NewsDetailStatus.loaded:
                if (state.selectedNews == null) {
                  return _buildError(null);
                }
                return _buildContent(context, state.selectedNews!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildError(String? error) {
    return SafeArea(
      child: Column(
        children: [
          _buildBackRow(context),
          Expanded(
            child: Center(
              child: Text(
                error ?? 'حدث خطأ',
                style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: Bounce(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_outlined,
                color: AppColors.primaryColor400,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                AppTexts.registerBack,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NewsModel news) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage(context, news),
          Transform.translate(
            offset: Offset(0, -24.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildShareButton(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 10.h),
                if (news.createdAt != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.sp,
                        color: AppColors.neutral400,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        news.createdAt!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.h),
                if (news.summary != null && news.summary!.isNotEmpty) ...[
                  Text(
                    news.summary!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral800,
                      height: 1.7,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                if (news.content != null && news.content!.isNotEmpty)
                  Text(
                    news.content!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.neutral700,
                      height: 1.8,
                    ),
                  ),
                if (news.gallery.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  _buildGalleryGrid(news.gallery),
                ],
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, NewsModel news) {
    return Stack(
      children: [
        SizedBox(
          height: 280.h,
          width: double.infinity,
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
                        size: 48.sp,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.neutral200,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.neutral400,
                        size: 48.sp,
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
                      size: 48.sp,
                    ),
                  ),
                ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          right: 16.w,
          left: 16.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bounce(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_outlined,
                      color: AppColors.primaryColor900,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      AppTexts.registerBack,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor900,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isAdmin) _buildPopupMenu(context, news),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context, NewsModel news) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_vert, color: AppColors.white, size: 20.sp),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      offset: Offset(0, 40.h),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.pushNamed(context, AppRoutes.addNews, arguments: news)
              .then((_) {
            context.read<NewsCubit>().loadNewsDetails(widget.newsId);
          });
        }
        else if (value == 'delete') {
          _confirmDelete(context, news);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined,
                  color: AppColors.primaryColor600, size: 18.sp),
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
              Icon(Icons.delete_outline,
                  color: AppColors.error600, size: 18.sp),
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

  Widget _buildShareButton() {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor600,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor900.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.share_outlined,
        color: AppColors.white,
        size: 20.sp,
      ),
    );
  }

  Widget _buildGalleryGrid(List<GalleryItem> gallery) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
        childAspectRatio: 1,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        final item = gallery[index];
        return Bounce(
          onTap: () => _showImageViewer(context, gallery, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: item.resolvedImageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.neutral200,
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.neutral200,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.neutral400,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageViewer(
      BuildContext context, List<GalleryItem> gallery, int initialIndex) {
    showDialog(
      context: context,
      builder: (_) => _ImageViewerDialog(
        gallery: gallery,
        initialIndex: initialIndex,
      ),
    );
  }

  void _confirmDelete(BuildContext context, NewsModel news) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
                Navigator.pop(context);
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

class _ImageViewerDialog extends StatefulWidget {
  const _ImageViewerDialog({
    required this.gallery,
    required this.initialIndex,
  });

  final List<GalleryItem> gallery;
  final int initialIndex;

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.gallery.length,
            itemBuilder: (_, index) {
              return InteractiveViewer(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.gallery[index].resolvedImageUrl ?? '',
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.white),
                    ),
                    errorWidget: (_, __, ___) => Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.white,
                      size: 48.sp,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            right: 16.w,
            child: Bounce(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: AppColors.white, size: 20.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.primaryColor900.withOpacity(0.35),
            highlightColor: AppColors.white.withOpacity(0.4),
            child: Container(
              height: 280.h,
              width: double.infinity,
              color: AppColors.neutral200,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.primaryColor900.withOpacity(0.35),
                  highlightColor: AppColors.white.withOpacity(0.4),
                  child: Container(
                    height: 20.h,
                    width: 0.8.sw,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Shimmer.fromColors(
                  baseColor: AppColors.primaryColor900.withOpacity(0.35),
                  highlightColor: AppColors.white.withOpacity(0.4),
                  child: Container(
                    height: 14.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ...List.generate(
                  5,
                  (i) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.primaryColor900.withOpacity(0.35),
                      highlightColor: AppColors.white.withOpacity(0.4),
                      child: Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, __) => Shimmer.fromColors(
                    baseColor: AppColors.primaryColor900.withOpacity(0.35),
                    highlightColor: AppColors.white.withOpacity(0.4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
