import 'package:al_shaher/core/routing/app_routes.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../register/data/models/application_form_summary.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.summary});

  final ApplicationFormSummary summary;

  String _genderLabel(String? code) {
    if (code == null || code.isEmpty) {
      return '—';
    }
    switch (code) {
      case 'female':
        return AppTexts.orderDetailsGenderFemale;
      case 'male':
      default:
        return AppTexts.orderDetailsGenderMale;
    }
  }

  String _formatBirthForDisplay(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

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
          Bounce(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.login),
            child: Row(
              children: [
                Text(
                  AppTexts.registerBack,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor700,
                  ),
                ),
                Icon(
                  Icons.chevron_left,
                  size: 22.sp,
                  color: AppColors.primaryColor700,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
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
                          '#${summary.imageId > 0 ? summary.imageId.toString().padLeft(4, '0') : '—'}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                        Text(
                         AppTexts.orderNumber,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _DetailItem(
                      label: AppTexts.serviceType,
                      value: AppTexts.orderDetailsServiceType,
                    ),
                    Divider(height: 22.h, color: AppColors.neutral100),
                    _DetailItem(label: AppTexts.name, value: summary.name),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.nationalId,
                      value: summary.nationalId,
                    ),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.orderDetailsPhone,
                      value: summary.phone,
                    ),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.orderDetailsBirthDate,
                      value: _formatBirthForDisplay(summary.dateOfBirthIso),
                    ),
                    SizedBox(height: 10.h),
                    _DetailItem(label: AppTexts.city, value: summary.city),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.orderDetailsGender,
                      value: _genderLabel(summary.gender),
                    ),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.orderDetailsRelationships,
                      value: summary.relationshipsDisplay,
                    ),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.orderDetailsBranch,
                      value: summary.branchName,
                    ),
                    // SizedBox(height: 10.h),
                    // _DetailItem(
                    //   label: AppTexts.orderDetailsBranchId,
                    //   value: summary.branchId.toString(),
                    // ),
                    SizedBox(height: 10.h),
                    _DetailItem(
                      label: AppTexts.orderDetailsFather,
                      value: summary.fatherName,
                    ),
                    // SizedBox(height: 10.h),
                    // _DetailItem(
                    //   label: AppTexts.orderDetailsFatherId,
                    //   value: summary.fatherId.toString(),
                    // ),
                    // SizedBox(height: 10.h),
                    // _DetailItem(
                    //   label: AppTexts.orderDetailsImageId,
                    //   value: summary.imageId.toString(),
                    // ),
                    SizedBox(height: 12.h),
                    Text(
                      AppTexts.relationSuccessSubtitle,
                      textAlign: TextAlign.center,
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
