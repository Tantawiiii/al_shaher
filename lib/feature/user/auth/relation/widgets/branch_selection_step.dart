import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import 'selection_item.dart';

class BranchSelectionStep extends StatelessWidget {
  const BranchSelectionStep({
    super.key,
    required this.onSelected,
  });

  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionItem(
          label: AppTexts.relationBranchDefault,
          onTap: () => onSelected('Al-Salmi'),
          isDropdown: true,
        ),
        SizedBox(height: 20.h),
        AppBounceButton.elevated(
          onPressed: () {},
          label: AppTexts.relationConfirm,
          backgroundColor: AppColors.primaryColor700,
        ),
      ],
    );
  }
}

