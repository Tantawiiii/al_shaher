import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../data/my_created_member_model.dart';
import '../data/requests_remote_data_source.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  late Future<List<MyCreatedMemberModel>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = sl<RequestsRemoteDataSource>().fetchMyCreatedMembers();
  }

  Future<void> _reload() async {
    setState(() {
      _requestsFuture = sl<RequestsRemoteDataSource>().fetchMyCreatedMembers();
    });
    await _requestsFuture;
  }

  String _statusText(MyCreatedMemberModel item) {
    if (item.active) return 'مقبول';
    if (item.dead) return 'تمت الإضافة (متوفى)';
    return 'قيد المراجعة';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.myRequests),
          backgroundColor: AppColors.primaryColor600,
          foregroundColor: AppColors.white,
        ),
        body: FutureBuilder<List<MyCreatedMemberModel>>(
          future: _requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor600,
                ),
              );
            }

            if (snapshot.hasError) {
              final error = snapshot.error.toString().replaceFirst(
                'Exception: ',
                '',
              );
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.neutral600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: _reload,
                        child: const Text(AppTexts.relationRetry),
                      ),
                    ],
                  ),
                ),
              );
            }

            final items = snapshot.data ?? const <MyCreatedMemberModel>[];
            if (items.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد طلبات حتى الآن',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.neutral500,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.neutral200),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text('رقم الطلب: ${item.applicationNumber}'),
                        if ((item.nationalId ?? '').isNotEmpty)
                          Text('رقم الهوية: ${item.nationalId}'),
                        if ((item.phone ?? '').isNotEmpty)
                          Text('الجوال: ${item.phone}'),
                        if ((item.dateOfBirth ?? '').isNotEmpty)
                          Text('تاريخ الميلاد: ${item.dateOfBirth}'),
                        if ((item.branchName ?? '').isNotEmpty)
                          Text('الفرع: ${item.branchName}'),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor100,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            _statusText(item),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
