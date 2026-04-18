import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_routes.dart';
import '../../members/data/member_detail_model.dart';
import '../../members/data/members_remote_data_source.dart';
import '../data/tree_member_model.dart';


class MemberPreviewSheet extends StatefulWidget {
  const MemberPreviewSheet({super.key, required this.member});

  final TreeMemberModel member;

  static Future<void> show(BuildContext context, TreeMemberModel member) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => MemberPreviewSheet(member: member),
    );
  }

  @override
  State<MemberPreviewSheet> createState() => _MemberPreviewSheetState();
}

class _MemberPreviewSheetState extends State<MemberPreviewSheet> {
  MemberDetailModel? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final data = await sl<MembersRemoteDataSource>()
          .fetchMemberDetails(widget.member.id);
      if (!mounted) return;
      setState(() {
        _detail = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  String? get _avatarUrl {
    final fromDetail = _detail?.imageUrl;
    if (fromDetail != null && fromDetail.isNotEmpty) {
      return normalizeTreeMediaUrl(fromDetail);
    }
    return widget.member.avatarUrl;
  }

  String get _name => _detail?.name.isNotEmpty == true
      ? _detail!.name
      : widget.member.name;

  String? get _branchName =>
      _detail?.branch?.name ?? widget.member.branch?.name;

  String? get _fatherName => _detail?.father?.name;

  String? get _motherName {
    final m = _detail?.motherName ?? widget.member.motherName;
    return (m != null && m.isNotEmpty) ? m : null;
  }

  String? get _dateOfBirth {
    final d = _detail?.dateOfBirth ?? widget.member.dateOfBirth;
    return (d != null && d.isNotEmpty) ? d : null;
  }

  String? get _city {
    final c = _detail?.city ?? widget.member.city;
    return (c != null && c.isNotEmpty) ? c : null;
  }

  String? get _wifeName {
    final w = _detail?.wifeName ?? widget.member.wifeName;
    return (w != null && w.isNotEmpty) ? w : null;
  }

  int get _childrenCount => widget.member.children.length;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(top: 38.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 56.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(20.w, 72.h, 20.w, 24.h + bottomInset),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCloseHeader(),
                  SizedBox(height: 4.h),
                  _buildTitle(),
                  SizedBox(height: 20.h),
                  _buildInfoList(),
                  SizedBox(height: 24.h),
                  _buildViewProfileButton(context),
                ],
              ),
            ),
          ),
          Positioned(top: 0, child: _buildAvatar()),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final url = _avatarUrl;
    final initials = _name.isNotEmpty ? _name[0] : '؟';

    return Container(
      width: 112.r,
      height: 112.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor200,
        border: Border.all(color: AppColors.white, width: 4.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: url != null
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (_, __) => _avatarFallback(initials),
              errorWidget: (_, __, ___) => _avatarFallback(initials),
            )
          : _avatarFallback(initials),
    );
  }

  Widget _avatarFallback(String initials) {
    return Container(
      color: AppColors.primaryColor500,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 36.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildCloseHeader() {
    return Row(
      children: [
        Bounce(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.neutral600,
              size: 20.sp,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          _name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
        if (_branchName != null) ...[
          SizedBox(height: 6.h),
          Text(
            AppTexts.treeBranchLine(_branchName!),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoList() {
    if (_loading && _detail == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: const CircularProgressIndicator(
          color: AppColors.primaryColor600,
          strokeWidth: 2.6,
        ),
      );
    }

    final rows = <Widget>[];
    if (_fatherName != null) {
      rows.add(_InfoRow(
        label: AppTexts.memberPreviewFatherLabel,
        value: _fatherName!,
        icon: Icons.person_outline,
      ));
    }
    if (_motherName != null) {
      rows.add(_InfoRow(
        label: AppTexts.memberPreviewMotherLabel,
        value: _motherName!,
        icon: Icons.person_outline,
      ));
    }
    if (_dateOfBirth != null) {
      rows.add(_InfoRow(
        label: AppTexts.memberPreviewBirthDateLabel,
        value: _formatDate(_dateOfBirth!),
        icon: Icons.cake_outlined,
      ));
    }
    if (_city != null) {
      rows.add(_InfoRow(
        label: AppTexts.memberPreviewCityLabel,
        value: _city!,
        icon: Icons.location_on_outlined,
      ));
    }
    if (_wifeName != null) {
      rows.add(_InfoRow(
        label: AppTexts.memberPreviewWifeLabel,
        value: _wifeName!,
        icon: Icons.person_outline,
      ));
    }
    if (_childrenCount > 0) {
      rows.add(_InfoRow(
        label: AppTexts.memberPreviewChildrenLabel,
        value: AppTexts.memberPreviewChildrenLine(_childrenCount),
        icon: Icons.groups_outlined,
      ));
    }

    if (rows.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          _error ?? AppTexts.memberPreviewNoExtraData,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.neutral500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildViewProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(
            AppRoutes.memberProfile,
            arguments: widget.member.id,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor600,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: AppColors.primaryColor600.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          AppTexts.memberPreviewViewProfile,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _formatDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return AppTexts.formatDateArabicDayMonthYear(dt);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.neutral100),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.neutral500,
                  ),
                ),
                if (value.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor600,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
