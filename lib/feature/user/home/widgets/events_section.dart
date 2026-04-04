import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../user/events/cubit/events_cubit.dart';
import '../../../user/events/cubit/events_state.dart';
import '../../../user/events/data/event_model.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
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
                    AppTexts.events,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                  if (state.status == EventsStatus.loaded &&
                      state.events.isNotEmpty)
                    Bounce(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.events),
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
            _buildContent(state),
          ],
        );
      },
    );
  }

  Widget _buildContent(EventsState state) {
    switch (state.status) {
      case EventsStatus.initial:
      case EventsStatus.loading:
        return const _EventsSectionShimmer();
      case EventsStatus.error:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Center(
            child: Text(
              state.errorMessage ?? 'حدث خطأ',
              style: TextStyle(fontSize: 13.sp, color: AppColors.neutral400),
            ),
          ),
        );
      case EventsStatus.loaded:
        if (state.events.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Center(
              child: Text(
                AppTexts.eventsEmpty,
                style: TextStyle(fontSize: 13.sp, color: AppColors.neutral400),
              ),
            ),
          );
        }
        final displayEvents = state.events.take(3).toList();
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayEvents.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) =>
              _EventCard(event: displayEvents[index]),
        );
    }
  }
}

class _EventsSectionShimmer extends StatelessWidget {
  const _EventsSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index < 2 ? 12.h : 0),
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryColor900.withOpacity(0.35),
              highlightColor: AppColors.white.withOpacity(0.4),
              child: Container(
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
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 4.w,
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: AppColors.neutral200,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 14.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.neutral200,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                height: 12.h,
                                width: 0.65.sw,
                                decoration: BoxDecoration(
                                  color: AppColors.neutral200,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final EventModel event;

  static const _arabicMonths = [
    '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  String _formatDateLine() {
    final parts = <String>[];
    if (event.date != null) {
      parts.add('${event.date!.day} ${_arabicMonths[event.date!.month]}');
    }
    if (event.time != null) {
      parts.add(event.time!);
    }
    return parts.join(' . ');
  }

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.eventDetails,
            arguments: event.id);
      },
      child: Container(
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4.w,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.accentGold600,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_formatDateLine().isNotEmpty)
                        Text(
                          _formatDateLine(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.neutral500,
                          ),
                        ),
                      SizedBox(height: 8.h),
                      Text(
                        event.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (event.description != null &&
                          event.description!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          event.description!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.neutral500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
