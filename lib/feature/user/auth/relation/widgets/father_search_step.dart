import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import '../../../../../core/widgets/app_form_text_field.dart';
import 'suggestion_item.dart';

class FatherSearchStep extends StatelessWidget {
  const FatherSearchStep({
    super.key,
    required this.onSelected,
  });

  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppFormTextField(
          hintText: AppTexts.relationFatherSearchHint,
          leadingIcon: Icon(Icons.search, color: AppColors.neutral400),
          trailing: Icon(Icons.close, size: 18.sp, color: AppColors.neutral400),
        ),
        SizedBox(height: 12.h),
        SuggestionItem(
          name: AppTexts.relationFatherDefault,
          year: '1951',
          onTap: () => onSelected('${AppTexts.relationFatherDefault} 1951'),
        ),
        SuggestionItem(
          name: AppTexts.relationFatherDefault,
          year: '1975',
          onTap: () => onSelected('${AppTexts.relationFatherDefault} 1975'),
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

