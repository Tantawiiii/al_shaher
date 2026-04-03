import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import '../../../../../core/widgets/app_form_text_field.dart';
import '../../register/data/models/member_model.dart';
import '../cubit/father_cubit.dart';
import '../cubit/father_state.dart';
import 'suggestion_item.dart';

class FatherSearchStep extends StatefulWidget {
  const FatherSearchStep({
    super.key,
    required this.branchId,
    required this.onConfirmed,
  });

  final int branchId;
  final void Function(MemberModel member) onConfirmed;

  @override
  State<FatherSearchStep> createState() => _FatherSearchStepState();
}

class _FatherSearchStepState extends State<FatherSearchStep> {
  final _searchController = TextEditingController();
  MemberModel? _selected;

  @override
  void initState() {
    super.initState();
    context.read<FatherCubit>().loadForBranch(widget.branchId);
  }

  @override
  void didUpdateWidget(FatherSearchStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchId != widget.branchId) {
      _selected = null;
      context.read<FatherCubit>().loadForBranch(widget.branchId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MemberModel> _filter(List<MemberModel> members, String q) {
    final t = q.trim();
    if (t.isEmpty) return members;
    return members
        .where((m) => m.name.contains(t))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FatherCubit, FatherState>(
      builder: (context, state) {
        if (state.loadStatus == FatherLoadStatus.loading) {
          return _FatherShimmerList();
        }
        if (state.loadStatus == FatherLoadStatus.failure) {
          return Column(
            children: [
              Text(
                state.errorMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => context
                    .read<FatherCubit>()
                    .loadForBranch(widget.branchId),
                child: Text(
                  AppTexts.relationRetry,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        }

        final members = state.members;
        if (members.isEmpty) {
          return Text(
            AppTexts.relationNoFathers,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: AppColors.white),
          );
        }

        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _searchController,
          builder: (context, value, _) {
            final filtered = _filter(members, value.text);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppFormTextField(
                  controller: _searchController,
                  hintText: AppTexts.relationVerificationFatherLabel,
                  leadingIcon:
                      Icon(Icons.search, color: AppColors.neutral400),
                  trailing: GestureDetector(
                    onTap: () {
                      _searchController.clear();
                    },
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: AppColors.neutral400,
                    ),
                  ),
                  fillColor: AppColors.white.withOpacity(0.95),
                ),
                SizedBox(height: 12.h),
                ...filtered.map(
                  (m) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: SuggestionItem(
                      name: m.name,
                      year: m.dateOfBirth != null && m.dateOfBirth!.length >= 4
                          ? m.dateOfBirth!.substring(0, 4)
                          : '—',
                      onTap: () => setState(() => _selected = m),
                      selected: _selected?.id == m.id,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                AppBounceButton.elevated(
                  onPressed: _selected == null
                      ? null
                      : () => widget.onConfirmed(_selected!),
                  label: AppTexts.relationConfirm,
                  backgroundColor: AppColors.primaryColor700,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _FatherShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Shimmer.fromColors(
            baseColor: AppColors.primaryColor900.withOpacity(0.35),
            highlightColor: AppColors.white.withOpacity(0.4),
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
