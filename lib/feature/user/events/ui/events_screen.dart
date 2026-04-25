import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';
import '../data/event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  DateTime _currentMonth = DateTime.now();
  late final bool _isAdmin;
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _isAdmin = sl<AuthLocalStorage>().getAuthType() == 'admin';
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
        floatingActionButton: _buildFab(),
        body: Column(
          children: [
            _buildAppBar(context),
            if (_isAdmin) _buildAdminHeaderTools() else _buildViewToggle(),
            Expanded(child: _isAdmin ? _buildAdminBody() : _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    if (!_isAdmin) return const SizedBox.shrink();
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.addEvent).then((_) {
          context.read<EventsCubit>().loadEvents();
        });
      },
      backgroundColor: AppColors.primaryColor600,
      child: Icon(Icons.add, color: AppColors.white, size: 28.sp),
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
            AppTexts.events,
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

  Widget _buildAdminHeaderTools() {
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
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value.trim()),
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
                onTap: () => setState(() => _sortAscending = !_sortAscending),
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
              BlocBuilder<EventsCubit, EventsState>(
                buildWhen: (p, c) => p.events != c.events,
                builder: (_, state) {
                  final visibleCount = _applyAdminFilters(state.events).length;
                  return Text(
                    '${AppTexts.events} ( $visibleCount )',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor600,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return BlocBuilder<EventsCubit, EventsState>(
      buildWhen: (p, c) => p.isCalendarView != c.isCalendarView,
      builder: (context, state) {
        return Container(
          color: AppColors.primaryColor600,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Bounce(
                    onTap: () {
                      if (!state.isCalendarView) return;
                      context.read<EventsCubit>().toggleView();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: !state.isCalendarView
                            ? AppColors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: !state.isCalendarView
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu,
                            size: 20.sp,
                            color: !state.isCalendarView
                                ? AppColors.primaryColor700
                                : AppColors.neutral500,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            AppTexts.eventsList,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: !state.isCalendarView
                                  ? AppColors.primaryColor700
                                  : AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Bounce(
                    onTap: () {
                      if (state.isCalendarView) return;
                      context.read<EventsCubit>().toggleView();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: state.isCalendarView
                            ? AppColors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: state.isCalendarView
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20.sp,
                            color: state.isCalendarView
                                ? AppColors.primaryColor700
                                : AppColors.neutral500,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            AppTexts.eventsCalendar,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: state.isCalendarView
                                  ? AppColors.primaryColor700
                                  : AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        switch (state.status) {
          case EventsStatus.initial:
          case EventsStatus.loading:
            return _buildLoading();
          case EventsStatus.error:
            return _buildError(state.errorMessage ?? 'حدث خطأ');
          case EventsStatus.loaded:
            return state.isCalendarView
                ? _buildCalendarView(state)
                : _buildListView(state);
        }
      },
    );
  }

  Widget _buildAdminBody() {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        switch (state.status) {
          case EventsStatus.initial:
          case EventsStatus.loading:
            return _buildLoading();
          case EventsStatus.error:
            return _buildError(state.errorMessage ?? 'حدث خطأ');
          case EventsStatus.loaded:
            return _buildAdminList(state.events);
        }
      },
    );
  }

  Widget _buildAdminList(List<EventModel> events) {
    final filtered = _applyAdminFilters(events);
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty ? AppTexts.eventsEmpty : 'لا توجد نتائج مطابقة',
          style: TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
        ),
      );
    }

    final grouped = _groupEventsByMonth(filtered);
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final entry = grouped.entries.elementAt(index);
        final month = entry.key;
        final items = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                month,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            ...items.map(_buildAdminEventCard),
          ],
        );
      },
    );
  }

  Widget _buildAdminEventCard(EventModel event) {
    return Bounce(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.eventDetails,
          arguments: event.id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAdminItemMenu(event),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900,
                      height: 1.4,
                    ),
                  ),
                  if (event.description != null &&
                      event.description!.trim().isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      event.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.neutral500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 10.w),
            _buildDateBadge(event.date),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminItemMenu(EventModel event) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, color: AppColors.neutral500, size: 20.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.pushNamed(context, AppRoutes.addEvent, arguments: event)
              .then((_) => context.read<EventsCubit>().loadEvents());
          return;
        }
        if (value == 'delete') {
          _confirmDeleteFromList(event);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.primaryColor600, size: 18.sp),
              SizedBox(width: 8.w),
              Text(AppTexts.eventsEdit),
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
                AppTexts.eventsDelete,
                style: const TextStyle(color: AppColors.error600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateBadge(DateTime? date) {
    if (date == null) {
      return Container(
        width: 58.w,
        height: 62.h,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(12.r),
        ),
      );
    }
    final months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return Container(
      width: 58.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.accentGold600,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          Text(
            months[date.month],
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteFromList(EventModel event) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            AppTexts.eventsDeleteConfirm,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppTexts.eventsDeleteMessage,
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
                context.read<EventsCubit>().deleteEvent(event.id);
                Fluttertoast.showToast(
                  msg: 'تم حذف المناسبة بنجاح',
                  backgroundColor: AppColors.success600,
                );
              },
              child: Text(
                AppTexts.eventsDelete,
                style: TextStyle(color: AppColors.error600, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<EventModel> _applyAdminFilters(List<EventModel> events) {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? List<EventModel>.from(events)
        : events.where((event) {
            final name = event.name.toLowerCase();
            final description = (event.description ?? '').toLowerCase();
            final location = (event.location ?? '').toLowerCase();
            final dateText = event.date != null ? _formatDate(event.date!) : '';
            return name.contains(query) ||
                description.contains(query) ||
                location.contains(query) ||
                dateText.toLowerCase().contains(query);
          }).toList();

    filtered.sort((a, b) {
      final ad = a.date ?? DateTime(1970);
      final bd = b.date ?? DateTime(1970);
      return _sortAscending ? ad.compareTo(bd) : bd.compareTo(ad);
    });
    return filtered;
  }

  Map<String, List<EventModel>> _groupEventsByMonth(List<EventModel> events) {
    final months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final map = <String, List<EventModel>>{};
    for (final event in events) {
      final key = event.date != null
          ? '${months[event.date!.month]} ${event.date!.year}'
          : 'بدون تاريخ';
      map.putIfAbsent(key, () => []).add(event);
    }
    return map;
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: const CircularProgressIndicator(
              color: AppColors.primaryColor600,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppTexts.eventsLoading,
            style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.error600,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: AppColors.neutral600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => context.read<EventsCubit>().loadEvents(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppTexts.relationRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor600,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── LIST VIEW ─────────────────────────────────────────────────────

  Widget _buildListView(EventsState state) {
    if (state.events.isEmpty) {
      return Center(
        child: Text(
          AppTexts.eventsEmpty,
          style: TextStyle(fontSize: 16.sp, color: AppColors.neutral400),
        ),
      );
    }

    final grouped = state.eventsByMonth;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final month = grouped.keys.elementAt(index);
        final items = grouped[month]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                month,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral700,
                ),
              ),
            ),
            ...items.map((event) => _buildEventCard(event)),
          ],
        );
      },
    );
  }

  Widget _buildEventCard(EventModel event) {
    final hasAttendance = event.myAttendance != null &&
        event.myAttendance!.isNotEmpty &&
        event.myAttendance != 'null';

    return Bounce(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.eventDetails,
          arguments: event.id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left teal accent bar
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor500,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Attendance badge
                    if (hasAttendance)
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getAttendanceColor(event.myAttendance!)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 14.sp,
                                    color: _getAttendanceColor(
                                        event.myAttendance!),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    _getAttendanceLabel(event.myAttendance!),
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _getAttendanceColor(
                                          event.myAttendance!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Title
                    Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral900,
                      ),
                    ),
                    if (event.description != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        event.description!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.neutral500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Date + Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (event.date != null)
                    Text(
                      _formatDate(event.date!),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.neutral500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (event.time != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      '${event.time} مساءً',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.neutral400,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── CALENDAR VIEW ─────────────────────────────────────────────────

  Widget _buildCalendarView(EventsState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildCalendar(state),
          SizedBox(height: 16.h),
          // Title
          Text(
            AppTexts.events,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral700,
            ),
          ),
          SizedBox(height: 8.h),
          // Filtered events
          ...(state.selectedDate != null
                  ? state.filteredEvents
                  : state.events)
              .map((e) => _buildEventCard(e)),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildCalendar(EventsState state) {
    final arabicMonths = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    final arabicDays = ['جمعة', 'سبت', 'أحد', 'اثنين', 'ثلاثاء', 'اربعاء', 'خميس'];

    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final daysInMonth = lastDay.day;

    // weekday: 1=Mon..7=Sun → shift for RTL Fri-start
    // Friday=5, Sat=6, Sun=7, Mon=1, Tue=2, Wed=3, Thu=4
    int startOffset = (firstDay.weekday + 2) % 7;

    final eventDates = state.eventsByDate;
    final today = DateTime.now();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bounce(
                onTap: () {
                  setState(() {
                    _currentMonth = DateTime(year, month + 1, 1);
                  });
                },
                child: Icon(
                  Icons.chevron_left,
                  color: AppColors.neutral700,
                  size: 24.sp,
                ),
              ),
              Text(
                '${arabicMonths[month]} $year',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              Bounce(
                onTap: () {
                  setState(() {
                    _currentMonth = DateTime(year, month - 1, 1);
                  });
                },
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.neutral700,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Day headers
          Row(
            children: arabicDays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 8.h),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox();
              }
              final day = index - startOffset + 1;
              final date = DateTime(year, month, day);
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isSelected = state.selectedDate != null &&
                  date.year == state.selectedDate!.year &&
                  date.month == state.selectedDate!.month &&
                  date.day == state.selectedDate!.day;
              final dateKey = DateTime(year, month, day);
              final hasEvent = eventDates.containsKey(dateKey);

              return Bounce(
                onTap: () {
                  context.read<EventsCubit>().selectDate(date);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryColor600
                        : isToday
                            ? AppColors.accentGold600
                            : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight:
                              (isToday || isSelected) ? FontWeight.w700 : FontWeight.w500,
                          color: (isSelected || isToday)
                              ? AppColors.white
                              : AppColors.neutral800,
                        ),
                      ),
                      if (hasEvent && !isSelected && !isToday)
                        Positioned(
                          bottom: 4.h,
                          child: Container(
                            width: 5.r,
                            height: 5.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ───────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    final months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${date.day} ${months[date.month]}';
  }

  Color _getAttendanceColor(String status) {
    switch (status) {
      case 'attending':
        return AppColors.success600;
      case 'not_attending':
        return AppColors.error600;
      default:
        return AppColors.warning600;
    }
  }

  String _getAttendanceLabel(String status) {
    switch (status) {
      case 'attending':
        return AppTexts.eventsAttending;
      case 'not_attending':
        return AppTexts.eventsNotAttending;
      default:
        return AppTexts.eventsPending;
    }
  }
}
