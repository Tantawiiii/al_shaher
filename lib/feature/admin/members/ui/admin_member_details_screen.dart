import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/feature/admin/members/cubit/admin_members_cubit.dart';
import 'package:al_shaher/feature/admin/members/cubit/admin_members_state.dart';
import 'package:al_shaher/feature/admin/members/data/admin_member_model.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminMemberDetailsScreen extends StatefulWidget {
  const AdminMemberDetailsScreen({
    super.key,
    required this.memberId,
    required this.activeFilter,
    required this.deletedFilter,
  });

  final int memberId;
  final bool activeFilter;
  final bool deletedFilter;

  @override
  State<AdminMemberDetailsScreen> createState() => _AdminMemberDetailsScreenState();
}

class _AdminMemberDetailsScreenState extends State<AdminMemberDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminMembersCubit>().loadMembers(
      active: widget.activeFilter,
      deleted: widget.deletedFilter,
    );
    context.read<AdminMembersCubit>().loadMemberDetails(widget.memberId);
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
            Expanded(
              child: BlocBuilder<AdminMembersCubit, AdminMembersState>(
                builder: (context, state) {
                  switch (state.detailStatus) {
                    case AdminMemberDetailStatus.initial:
                    case AdminMemberDetailStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor600,
                        ),
                      );
                    case AdminMemberDetailStatus.error:
                      return Center(child: Text(state.detailError ?? 'حدث خطأ'));
                    case AdminMemberDetailStatus.loaded:
                      final member = state.selectedMember;
                      if (member == null) return const SizedBox.shrink();
                      return _buildContent(member, state.actionLoading);
                  }
                },
              ),
            ),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor700, AppColors.primaryColor600],
        ),
      ),
      child: Row(
        children: [
          Bounce(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_ios_outlined,
                    color: AppColors.white, size: 16.sp),
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
            'تفاصيل الطلب',
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

  Widget _buildContent(AdminMemberModel m, bool actionLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 34.r,
                backgroundColor: AppColors.neutral200,
                backgroundImage: m.imageUrl != null
                    ? CachedNetworkImageProvider(m.imageUrl!)
                    : null,
              ),
            ),
            SizedBox(height: 16.h),
            _row('رقم الطلب', '#${m.id}'),
            _row('الاسم', m.name),
            _row('رقم الهوية', m.nationalId ?? '-'),
            _row('صلة القرابة', m.fatherName ?? '-'),
            _row('اسم الأب', m.fatherName ?? '-'),
            _row('رقم الجوال', m.phone ?? '-'),
            _row('تاريخ الميلاد', m.dateOfBirth ?? '-'),
            _row('الجنس', m.gender == 'male' ? 'ذكر' : 'أنثى'),
            _row('المدينة', m.city ?? '-'),
            _row('الحالة', m.active ? 'مقبول' : 'قيد المراجعة'),
            _row('متوفي', m.dead ? 'نعم' : 'لا'),
            SizedBox(height: 20.h),
            if (actionLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor600),
              )
            else ...[
              _actionBtn(
                m.active ? 'ارجاع الطلب' : 'قبول الطلب',
                AppColors.primaryColor600,
                AppColors.white,
                () async {
                  await context.read<AdminMembersCubit>().toggleActive(m.id);
                  if (!mounted) return;
                  Fluttertoast.showToast(msg: 'تم تغيير حالة التفعيل');
                },
              ),
              SizedBox(height: 10.h),
              _actionBtn(
                m.dead ? 'إلغاء حالة الوفاة' : 'تحديد كمتوفي',
                Colors.transparent,
                m.dead ? AppColors.warning600 : AppColors.neutral700,
                () async {
                  await context.read<AdminMembersCubit>().toggleDead(m.id);
                  if (!mounted) return;
                  Fluttertoast.showToast(msg: 'تم تغيير حالة الوفاة');
                },
                borderColor: m.dead ? AppColors.warning600 : AppColors.neutral300,
              ),
              SizedBox(height: 10.h),
              _actionBtn(
                'رفض الطلب',
                Colors.transparent,
                AppColors.error600,
                () async {
                  await context.read<AdminMembersCubit>().deleteMember(m.id);
                  if (!mounted) return;
                  Fluttertoast.showToast(msg: 'تم حذف العضو');
                  Navigator.pop(context, true);
                },
                borderColor: AppColors.error600,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(color: AppColors.neutral500, fontSize: 13.sp),
            ),
          ),
          Expanded(
            child: Text(
              v,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColors.neutral900,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    String title,
    Color bg,
    Color fg,
    VoidCallback onTap, {
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
