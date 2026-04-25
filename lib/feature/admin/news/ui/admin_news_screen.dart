import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/core/routing/app_routes.dart';
import 'package:al_shaher/feature/admin/news/ui/widgets/admin_news_header_tools.dart';
import 'package:al_shaher/feature/admin/news/ui/widgets/admin_news_list_item.dart';
import 'package:al_shaher/feature/user/news/cubit/news_cubit.dart';
import 'package:al_shaher/feature/user/news/cubit/news_state.dart';
import 'package:al_shaher/feature/user/news/data/news_model.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminNewsScreen extends StatefulWidget {
  const AdminNewsScreen({super.key});

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addNews).then((_) {
              context.read<NewsCubit>().loadNews();
            });
          },
          backgroundColor: AppColors.primaryColor600,
          child: const Icon(Icons.add, color: AppColors.white),
        ),
        body: Column(
          children: [
            _buildAppBar(context),
            BlocBuilder<NewsCubit, NewsState>(
              buildWhen: (p, c) => p.newsList != c.newsList,
              builder: (_, state) {
                final visibleCount = _applyFilters(state.newsList).length;
                return AdminNewsHeaderTools(
                  searchController: _searchController,
                  onSearchChanged: (value) =>
                      setState(() => _searchQuery = value.trim()),
                  onToggleSort: () =>
                      setState(() => _sortAscending = !_sortAscending),
                  visibleCount: visibleCount,
                );
              },
            ),
            Expanded(child: _buildBody()),
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

  Widget _buildBody() {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        switch (state.status) {
          case NewsStatus.initial:
          case NewsStatus.loading:
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor600),
            );
          case NewsStatus.error:
            return Center(
              child: Text(
                state.errorMessage ?? 'حدث خطأ',
                style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
              ),
            );
          case NewsStatus.loaded:
            return _buildNewsList(state.newsList);
        }
      },
    );
  }

  Widget _buildNewsList(List<NewsModel> newsList) {
    final filtered = _applyFilters(newsList);
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty ? AppTexts.newsEmpty : 'لا توجد نتائج مطابقة',
          style: TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final news = filtered[index];
        return AdminNewsListItem(
          news: news,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.newsDetails,
            arguments: news.id,
          ),
          onEdit: () {
            Navigator.pushNamed(context, AppRoutes.addNews, arguments: news)
                .then((_) => context.read<NewsCubit>().loadNews());
          },
          onDelete: () => _confirmDelete(news),
        );
      },
    );
  }

  void _confirmDelete(NewsModel news) {
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

  List<NewsModel> _applyFilters(List<NewsModel> list) {
    final query = _searchQuery.toLowerCase();
    final filtered = query.isEmpty
        ? List<NewsModel>.from(list)
        : list.where((news) {
            return news.title.toLowerCase().contains(query) ||
                (news.summary ?? '').toLowerCase().contains(query) ||
                (news.content ?? '').toLowerCase().contains(query) ||
                (news.createdAt ?? '').toLowerCase().contains(query);
          }).toList();

    filtered.sort((a, b) {
      final ad = a.createdAt ?? '';
      final bd = b.createdAt ?? '';
      return _sortAscending ? ad.compareTo(bd) : bd.compareTo(ad);
    });
    return filtered;
  }
}
