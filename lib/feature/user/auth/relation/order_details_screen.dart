import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor700,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppTexts.orderDetailsHeader,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: Icon(Icons.chevron_right, color: AppColors.white, size: 24.sp),
            label: Text(
              AppTexts.registerBack,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.warning100,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          AppTexts.orderDetailsStatus,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning600,
                          ),
                        ),
                      ),
                      Text(
                        '#0317',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                      Text(
                        'رقم الطلب',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.neutral400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _DetailItem(label: 'نوع الخدمة', value: AppTexts.orderDetailsServiceType),
                  Divider(height: 32.h, color: AppColors.neutral100),
                  _DetailItem(label: 'الاسم', value: 'يوسف ابراهيم خالد ال شاهر'),
                  SizedBox(height: 16.h),
                  _DetailItem(label: 'رقم الهوية', value: '100034455883'),
                  SizedBox(height: 16.h),
                  _DetailItem(label: 'تاريخ الميلاد', value: '1985 فبراير 07'),
                  SizedBox(height: 16.h),
                  _DetailItem(label: 'المدينة', value: 'الرياض'),
                  SizedBox(height: 32.h),
                  Text(
                    'نص تجريبي لتفاصيل الطلب يكتب هنا نص تجريب يكتب هنا نص تجريبي لتفاصيل الطلب يكتب نص تجريبي يكتب هنا',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.neutral400,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.neutral400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor900,
          ),
        ),
      ],
    );
  }
}
