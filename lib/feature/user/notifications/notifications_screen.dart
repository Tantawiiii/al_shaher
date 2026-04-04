import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_item.dart';
import 'widgets/notification_section_title.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor700,
        body: Column(
          children: [
            const NotificationHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    20.verticalSpace,
                    const NotificationSectionTitle(title: AppTexts.notificationsToday),
                    10.verticalSpace,
                    const NotificationItem(
                      title: 'تم قبول طلب انضمامك',
                      subtitle: 'تفاصيل المناسبة يكتب هنا نص تجريبي لتفاصيل',
                      time: '9 دقيقة',
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.success600,
                    ),
                    10.verticalSpace,
                    const NotificationItem(
                      title: 'لديك طلب غير مكتمل',
                      subtitle: 'نص تجريبي لتفاصيل الحدث يكتب هنا نبذة مختصرة',
                      time: '18 دقيقة',
                      icon: Icons.info_outline,
                      iconColor: Colors.blue,
                    ),
                    10.verticalSpace,
                    const NotificationItem(
                      title: 'فعالية جديدة بانتظارك',
                      subtitle: 'نص تجريبي يكتب هنا نبذة مختصرة للتفاصيل عن الفعالية هنا',
                      time: '2 ساعة',
                      imageUrl: 'https://i.pravatar.cc/150?u=123',
                    ),
                    20.verticalSpace,
                    const NotificationSectionTitle(title: AppTexts.notificationsYesterday),
                    10.verticalSpace,
                    const NotificationItem(
                      title: 'تم قبول طلب 7844#',
                      subtitle: 'تفاصيل المناسبة يكتب هنا نص تجريبي لتفاصيل',
                      time: '16 مارس',
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.success600,
                    ),
                    10.verticalSpace,
                    const NotificationItem(
                      title: 'تم رفض طلبك 5627#',
                      subtitle: 'نص تجريبي لتفاصيل الحدث يكتب هنا نبذة مختصرة',
                      time: '16 مارس',
                      icon: Icons.error_outline,
                      iconColor: AppColors.warning600,
                    ),
                    10.verticalSpace,
                    const NotificationItem(
                      title: 'فعالية جديدة بانتظارك',
                      subtitle: 'نص تجريبي يكتب هنا نبذة مختصرة للتفاصيل عن الفعالية هنا',
                      time: '16 مارس',
                      imageUrl: 'https://i.pravatar.cc/150?u=456',
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
