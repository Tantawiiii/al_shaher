import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import '../../register/data/models/branch_model.dart';
import '../cubit/branch_cubit.dart';
import '../cubit/branch_state.dart';
import 'selection_item.dart';

class BranchSelectionStep extends StatefulWidget {
  const BranchSelectionStep({
    super.key,
    required this.onConfirmed,
  });

  final void Function(BranchModel branch) onConfirmed;

  @override
  State<BranchSelectionStep> createState() => _BranchSelectionStepState();
}

class _BranchSelectionStepState extends State<BranchSelectionStep> {
  BranchModel? _selected;

  Future<void> _openPicker(List<BranchModel> branches) async {
    if (branches.isEmpty) return;
    final picked = await showModalBottomSheet<BranchModel>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
          ),
          child: SafeArea(
            top: false,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: branches.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1.h, color: AppColors.neutral100),
              itemBuilder: (context, index) {
                final b = branches[index];
                return ListTile(
                  onTap: () => Navigator.pop(context, b),
                  title: Text(
                    b.name,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor900,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
    if (!mounted || picked == null) return;
    setState(() => _selected = picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchCubit, BranchState>(
      builder: (context, state) {
        if (state.loadStatus == BranchLoadStatus.loading ||
            state.loadStatus == BranchLoadStatus.initial) {
          return _BranchShimmerList();
        }
        if (state.loadStatus == BranchLoadStatus.failure) {
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
                onPressed: () =>
                    context.read<BranchCubit>().fetchBranches(),
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

        final branches = state.branches;
        if (branches.isEmpty) {
          return Text(
            AppTexts.relationNoBranches,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: AppColors.white),
          );
        }

        final label = _selected?.name ?? AppTexts.relationBranchDefault;

        return Column(
          children: [
            SelectionItem(
              label: label,
              onTap: () => _openPicker(branches),
              isDropdown: true,
            ),
            SizedBox(height: 20.h),
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
  }
}

class _BranchShimmerList extends StatelessWidget {
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
              height: 48.h,
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
