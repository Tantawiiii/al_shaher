import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/routing/app_routes.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';
import '../data/event_model.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EventsCubit>().loadEventDetails(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        body: Column(
          children: [
            _buildAppBar(context),
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
            AppTexts.eventsDetails,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          BlocBuilder<EventsCubit, EventsState>(
            builder: (context, state) {
              if (state.selectedEvent == null) return SizedBox(width: 60.w);
              return PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                  size: 24.sp,
                ),
                onSelected: (value) => _onMenuAction(value, state.selectedEvent!),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18.sp, color: AppColors.primaryColor600),
                        SizedBox(width: 8.w),
                        Text(AppTexts.eventsEdit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18.sp, color: AppColors.error600),
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
            },
          ),
        ],
      ),
    );
  }

  void _onMenuAction(String action, EventModel event) {
    if (action == 'edit') {
      Navigator.pushNamed(
        context,
        AppRoutes.addEvent,
        arguments: event,
      ).then((_) {
        context.read<EventsCubit>().loadEventDetails(widget.eventId);
      });
    } else if (action == 'delete') {
      _showDeleteConfirmation(event);
    }
  }

  void _showDeleteConfirmation(EventModel event) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            AppTexts.eventsDeleteConfirm,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            AppTexts.eventsDeleteMessage,
            style: TextStyle(fontSize: 14.sp, color: AppColors.neutral600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppTexts.eventsCancel,
                style: TextStyle(color: AppColors.neutral600),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<EventsCubit>().deleteEvent(event.id);
                Navigator.pop(context);
              },
              child: Text(
                AppTexts.eventsDelete,
                style: const TextStyle(color: AppColors.error600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        switch (state.detailStatus) {
          case EventDetailStatus.initial:
          case EventDetailStatus.loading:
            return _buildLoading();
          case EventDetailStatus.error:
            return _buildError(state.detailError ?? 'حدث خطأ');
          case EventDetailStatus.loaded:
            if (state.selectedEvent == null) {
              return _buildError('لا توجد بيانات');
            }
            return _buildDetails(state.selectedEvent!, state);
        }
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor600,
        strokeWidth: 3,
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(EventModel event, EventsState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Info Card
          _buildInfoCard(event),
          SizedBox(height: 16.h),

          // Stats Card
          _buildStatsCard(event),
          SizedBox(height: 16.h),

          // Attendance Actions
          _buildAttendanceSection(event, state),
          SizedBox(height: 16.h),

          // Attendees list
          if (event.attendees.isNotEmpty) _buildAttendeesSection(event),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildInfoCard(EventModel event) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral900,
            ),
          ),
          if (event.description != null) ...[
            SizedBox(height: 8.h),
            Text(
              event.description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.neutral600,
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: 16.h),
          Divider(color: AppColors.neutral200, height: 1),
          SizedBox(height: 16.h),
          // Date
          _buildInfoRow(
            Icons.calendar_today_outlined,
            AppTexts.eventsDate,
            event.date != null ? _formatFullDate(event.date!) : '-',
          ),
          SizedBox(height: 12.h),
          // Time
          _buildInfoRow(
            Icons.access_time_rounded,
            AppTexts.eventsTime,
            event.time ?? '-',
          ),
          SizedBox(height: 12.h),
          // Location
          _buildInfoRow(
            Icons.location_on_outlined,
            AppTexts.eventsLocation,
            event.location ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: AppColors.primaryColor700,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.neutral400,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCard(EventModel event) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.eventsStatistics,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral900,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildStatItem(
                AppTexts.eventsTotal,
                '${event.statistics.total}',
                AppColors.primaryColor600,
              ),
              _buildStatItem(
                AppTexts.eventsAttending,
                '${event.statistics.attending}',
                AppColors.success600,
              ),
              _buildStatItem(
                AppTexts.eventsNotAttending,
                '${event.statistics.notAttending}',
                AppColors.error600,
              ),
              _buildStatItem(
                AppTexts.eventsPending,
                '${event.statistics.pending}',
                AppColors.warning600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSection(EventModel event, EventsState state) {
    final current = event.myAttendance;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.eventsMyAttendance,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral900,
            ),
          ),
          SizedBox(height: 16.h),
          if (state.attendanceLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor600,
                strokeWidth: 2,
              ),
            )
          else
            Row(
              children: [
                _buildAttendanceButton(
                  label: AppTexts.eventsAttending,
                  icon: Icons.check_circle_outline,
                  color: AppColors.success600,
                  isSelected: current == 'attending',
                  onTap: () => _onAttendance('attending'),
                ),
                SizedBox(width: 8.w),
                _buildAttendanceButton(
                  label: AppTexts.eventsNotAttending,
                  icon: Icons.cancel_outlined,
                  color: AppColors.error600,
                  isSelected: current == 'not_attending',
                  onTap: () => _onAttendance('not_attending'),
                ),
                SizedBox(width: 8.w),
                _buildAttendanceButton(
                  label: AppTexts.eventsPending,
                  icon: Icons.help_outline,
                  color: AppColors.warning600,
                  isSelected: current == 'pending',
                  onTap: () => _onAttendance('pending'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Bounce(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.12) : AppColors.neutral50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? color : AppColors.neutral200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22.sp, color: isSelected ? color : AppColors.neutral400),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : AppColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAttendance(String status) {
    _showAttendanceDialog(status);
  }

  void _showAttendanceDialog(String status) {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.neutral300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppTexts.eventsAddNote,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: noteController,
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: AppTexts.eventsNoteHint,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.neutral400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor600),
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<EventsCubit>().recordAttendance(
                              eventId: widget.eventId,
                              status: status,
                              note: noteController.text,
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor600,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        AppTexts.relationConfirm,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendeesSection(EventModel event) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppTexts.eventsAttendees,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${event.attendees.length}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...event.attendees.map((a) => _buildAttendeeItem(a)),
        ],
      ),
    );
  }

  Widget _buildAttendeeItem(EventAttendee attendee) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primaryColor100,
            backgroundImage: attendee.imageUrl != null
                ? CachedNetworkImageProvider(attendee.imageUrl!)
                : null,
            child: attendee.imageUrl == null
                ? Text(
                    attendee.name.isNotEmpty ? attendee.name[0] : '?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor700,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendee.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral900,
                  ),
                ),
                if (attendee.branchName != null)
                  Text(
                    'فرع ${attendee.branchName}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.neutral400,
                    ),
                  ),
              ],
            ),
          ),
          if (attendee.phone != null)
            Icon(
              Icons.phone_outlined,
              size: 18.sp,
              color: AppColors.primaryColor500,
            ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
