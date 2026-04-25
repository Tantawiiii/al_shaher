import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/core/routing/app_routes.dart';
import 'package:al_shaher/feature/admin/events/ui/widgets/admin_event_list_item.dart';
import 'package:al_shaher/feature/admin/events/ui/widgets/admin_events_header_tools.dart';
import 'package:al_shaher/feature/user/events/cubit/events_cubit.dart';
import 'package:al_shaher/feature/user/events/cubit/events_state.dart';
import 'package:al_shaher/feature/user/events/data/event_model.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminEventsScreen extends StatefulWidget {
  const AdminEventsScreen({super.key});

  @override
  State<AdminEventsScreen> createState() => _AdminEventsScreenState();
}

class _AdminEventsScreenState extends State<AdminEventsScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _sortAscending = true;

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
            Navigator.pushNamed(context, AppRoutes.addEvent).then((_) {
              context.read<EventsCubit>().loadEvents();
            });
          },
          backgroundColor: AppColors.primaryColor600,
          child: Icon(Icons.add, color: AppColors.white, size: 28.sp),
        ),
        body: Column(
          children: [
            _buildAppBar(context),
            BlocBuilder<EventsCubit, EventsState>(
              buildWhen: (p, c) => p.events != c.events,
              builder: (_, state) {
                final visibleCount = _applyFilters(state.events).length;
                return AdminEventsHeaderTools(
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
            return _buildAdminList(state.events);
        }
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: SizedBox(
        width: 40.r,
        height: 40.r,
        child: const CircularProgressIndicator(
          color: AppColors.primaryColor600,
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: AppColors.neutral600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => context.read<EventsCubit>().loadEvents(),
              child: Text(AppTexts.relationRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminList(List<EventModel> events) {
    final filtered = _applyFilters(events);
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty ? AppTexts.eventsEmpty : 'لا توجد نتائج مطابقة',
          style: TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
        ),
      );
    }

    final grouped = _groupByMonth(filtered);
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final entry = grouped.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            ...entry.value.map(
              (event) => AdminEventListItem(
                event: event,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.eventDetails,
                    arguments: event.id,
                  );
                },
                onEdit: () {
                  Navigator.pushNamed(context, AppRoutes.addEvent, arguments: event)
                      .then((_) => context.read<EventsCubit>().loadEvents());
                },
                onDelete: () => _confirmDelete(event),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(EventModel event) {
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

  List<EventModel> _applyFilters(List<EventModel> events) {
    final query = _searchQuery.toLowerCase();
    final filtered = query.isEmpty
        ? List<EventModel>.from(events)
        : events.where((event) {
            final dateText = event.date != null ? _formatDate(event.date!) : '';
            return event.name.toLowerCase().contains(query) ||
                (event.description ?? '').toLowerCase().contains(query) ||
                (event.location ?? '').toLowerCase().contains(query) ||
                dateText.toLowerCase().contains(query);
          }).toList();

    filtered.sort((a, b) {
      final ad = a.date ?? DateTime(1970);
      final bd = b.date ?? DateTime(1970);
      return _sortAscending ? ad.compareTo(bd) : bd.compareTo(ad);
    });
    return filtered;
  }

  Map<String, List<EventModel>> _groupByMonth(List<EventModel> events) {
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

    final grouped = <String, List<EventModel>>{};
    for (final event in events) {
      final key = event.date != null
          ? '${months[event.date!.month]} ${event.date!.year}'
          : 'بدون تاريخ';
      grouped.putIfAbsent(key, () => []).add(event);
    }
    return grouped;
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month]}';
  }
}
