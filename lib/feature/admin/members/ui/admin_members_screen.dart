import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/core/routing/app_routes.dart';
import 'package:al_shaher/feature/admin/members/cubit/admin_members_cubit.dart';
import 'package:al_shaher/feature/admin/members/cubit/admin_members_state.dart';
import 'package:al_shaher/feature/admin/members/data/admin_member_model.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminMembersScreen extends StatefulWidget {
  const AdminMembersScreen({
    super.key,
    required this.initialActiveFilter,
    required this.title,
  });

  final bool initialActiveFilter;
  final String title;

  @override
  State<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends State<AdminMembersScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  String _searchQuery = '';
  bool _activeFilter = true;
  bool _deletedFilter = false;
  bool _isSearching = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _activeFilter = widget.initialActiveFilter;
    context.read<AdminMembersCubit>().loadMembers(
      active: _activeFilter,
      deleted: _deletedFilter,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 20.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor700, AppColors.primaryColor600],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _isSearching
                  ? Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v.trim()),
                        style: const TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
                          hintText: AppTexts.treeSearchHint,
                          hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7)),
                          prefixIcon: const Icon(Icons.search, color: AppColors.white),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close, color: AppColors.white),
                            onPressed: () => setState(() {
                              _isSearching = false;
                              _searchQuery = '';
                              _searchController.clear();
                            }),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  : Bounce(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_outlined, color: AppColors.white, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            AppTexts.registerBack,
                            style: TextStyle(color: AppColors.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
              if (!_isSearching) const Spacer(),
              if (!_isSearching)
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              if (!_isSearching) const Spacer(),
              if (!_isSearching)
                Bounce(
                  onTap: () => setState(() => _isSearching = true),
                  child: Icon(Icons.search, color: AppColors.white, size: 24.sp),
                ),
            ],
          ),
          SizedBox(height: 28.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: AppColors.white, width: 1.w),
            ),
            child: Row(
              children: widget.initialActiveFilter
                  ? [
                      _buildSegment(AppTexts.adminFilterAll, true, false),
                      _buildSegment(AppTexts.adminFilterRecentlyJoined, false, false),
                      _buildSegment(AppTexts.adminFilterBlocked, false, true),
                    ]
                  : [
                      _buildSegment(AppTexts.adminFilterUnderReview, false, false),
                      _buildSegment(AppTexts.adminFilterAccepted, true, false),
                      _buildSegment(AppTexts.adminFilterRejected, false, true),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(String title, bool active, bool deleted) {
    final selected = _activeFilter == active && _deletedFilter == deleted;
    return Expanded(
      child: Bounce(
        onTap: () {
          if (selected) return;
          setState(() {
            _activeFilter = active;
            _deletedFilter = deleted;
          });
          context.read<AdminMembersCubit>().loadMembers(
            active: active,
            deleted: deleted,
          );
        },
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: selected ? AppColors.primaryColor700 : AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AdminMembersCubit, AdminMembersState>(
      builder: (context, state) {
        switch (state.status) {
          case AdminMembersStatus.initial:
          case AdminMembersStatus.loading:
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor600),
            );
          case AdminMembersStatus.error:
            return Center(child: Text(state.errorMessage ?? AppTexts.adminError));
          case AdminMembersStatus.loaded:
            final filtered = _applySearch(state.members);
            return Column(
              children: [
                _buildSubHeader(filtered.length),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            _searchQuery.isEmpty ? AppTexts.treeNoData : AppTexts.adminNoSearchResults,
                          ),
                        )
                      : _isGridView
                          ? GridView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) => _buildGridItem(filtered[i]),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) => _buildListItem(filtered[i]),
                            ),
                ),
              ],
            );
        }
      },
    );
  }

  Widget _buildSubHeader(int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Bounce(
            onTap: () => setState(() => _isGridView = true),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: _isGridView ? AppColors.primaryColor600.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.grid_view_rounded,
                  size: 20.sp, color: _isGridView ? AppColors.primaryColor600 : AppColors.neutral400),
            ),
          ),
          SizedBox(width: 4.w),
          Bounce(
            onTap: () => setState(() => _isGridView = false),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: !_isGridView ? AppColors.primaryColor600.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.menu_rounded,
                  size: 20.sp, color: !_isGridView ? AppColors.primaryColor600 : AppColors.neutral400),
            ),
          ),
          const Spacer(),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'العدد الكلي ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.neutral600,
                  ),
                ),
                TextSpan(
                  text: '$count',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(AdminMemberModel m) {
    return Bounce(
      onTap: () => _navigateToDetails(m),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Icon(Icons.more_vert, color: AppColors.neutral400, size: 20.sp),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.neutral100, width: 2),
                    ),
                    child: ClipOval(
                      child: m.imageUrl != null
                          ? CachedNetworkImage(imageUrl: m.imageUrl!, fit: BoxFit.cover)
                          : Container(color: AppColors.neutral100, child: Icon(Icons.person, color: AppColors.neutral400)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    m.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.neutral900),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'آخر زيارة : 9 مارس', // Placeholder as per image or dynamic if available
                    style: TextStyle(fontSize: 11.sp, color: AppColors.neutral500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(AdminMemberModel m) {
    return Bounce(
      onTap: () => _navigateToDetails(m),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: m.imageUrl != null
                  ? CachedNetworkImage(imageUrl: m.imageUrl!, width: 60.w, height: 60.w, fit: BoxFit.cover)
                  : Container(
                      width: 60.w,
                      height: 60.w,
                      color: AppColors.neutral200,
                      child: const Icon(Icons.person_outline),
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.name,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.neutral900),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    m.phone ?? '-',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.neutral500),
                  ),
                  if (m.branchName != null)
                    Text(
                      '${AppTexts.memberPreviewBranchPrefix}${m.branchName}',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.neutral500),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: m.active ? AppColors.success600.withOpacity(0.1) : AppColors.warning600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _deletedFilter
                    ? AppTexts.adminFilterRejected
                    : (m.active ? AppTexts.adminFilterAccepted : AppTexts.adminFilterUnderReview),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: _deletedFilter ? AppColors.error600 : (m.active ? AppColors.success600 : AppColors.warning600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(AdminMemberModel m) {
    Navigator.pushNamed(
      context,
      AppRoutes.adminMemberDetails,
      arguments: {
        'id': m.id,
        'activeFilter': _activeFilter,
        'deletedFilter': _deletedFilter,
      },
    ).then((_) {
      context.read<AdminMembersCubit>().loadMembers(
            active: _activeFilter,
            deleted: _deletedFilter,
          );
    });
  }

  List<AdminMemberModel> _applySearch(List<AdminMemberModel> list) {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return list;
    return list.where((m) {
      return m.name.toLowerCase().contains(q) ||
          (m.phone ?? '').toLowerCase().contains(q) ||
          (m.nationalId ?? '').toLowerCase().contains(q) ||
          (m.city ?? '').toLowerCase().contains(q);
    }).toList();
  }
}

