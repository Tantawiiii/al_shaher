import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import '../../../../../core/widgets/app_form_text_field.dart';


class RelationStepCard extends StatelessWidget {
  const RelationStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.child,
    this.isCompleted = false,
    this.showLine = true,
  });

  final String stepNumber;
  final String title;
  final String subtitle;
  final Widget child;
  final bool isCompleted;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Connecting Line
        if (showLine)
          Positioned(
            right: -1.w, // Center of the circle indicator (-15.w + 15.r - 1.w)
            // Wait, my previous calculation was: right: -15.w + 15.r, 
            // but the circle is right: -15.w. 
            // Let's use a more robust way to center it.
            top: 20.h + 30.r,
            bottom: -20.h, // Extend beyond the card to meet the next one
            child: Container(
              width: 2.w,
              color: AppColors.accentGold600.withOpacity(0.5),
            ),
          ),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.neutral500,
                ),
              ),
              SizedBox(height: 20.h),
              child,
            ],
          ),
        ),
        // Step Indicator Circle
        Positioned(
          right: -15.w,
          top: 20.h,
          child: Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.primaryColor700 : AppColors.white,
              border: Border.all(
                color: isCompleted ? AppColors.primaryColor700 : AppColors.accentGold600,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, size: 18.sp, color: AppColors.white)
                  : Text(
                      stepNumber,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGold600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class RelationshipSelectionStep extends StatelessWidget {
  const RelationshipSelectionStep({
    super.key,
    required this.onSelected,
  });

  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SelectionItem(
          label: 'أنا أحد أفراد العائلة',
          onTap: () => onSelected('member'),
        ),
        SizedBox(height: 20.h),
        AppBounceButton.elevated(
          onPressed: () {}, // Handled by selection for now
          label: AppTexts.relationConfirm,
          backgroundColor: AppColors.primaryColor700,
        ),
      ],
    );
  }
}

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
        _SelectionItem(
          label: 'فرع السالمي',
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
          hintText: 'عبد الرحمن',
          leadingIcon: Icon(Icons.search, color: AppColors.neutral400),
          trailing: Icon(Icons.close, size: 18.sp, color: AppColors.neutral400),
        ),
        SizedBox(height: 12.h),
        _SuggestionItem(
          name: 'عبد الرحمن مجاهد',
          year: '1951',
          onTap: () => onSelected('عبد الرحمن مجاهد 1951'),
        ),
        _SuggestionItem(
          name: 'عبد الرحمن مجاهد',
          year: '1975',
          onTap: () => onSelected('عبد الرحمن مجاهد 1975'),
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

class VerificationStep extends StatelessWidget {
  const VerificationStep({
    super.key,
    required this.relationship,
    required this.branch,
    required this.fatherName,
    required this.onContinue,
  });

  final String relationship;
  final String branch;
  final String fatherName;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(label: 'العلاقة', value: relationship),
        _InfoRow(label: 'الفرع', value: branch),
        _InfoRow(label: 'الاب', value: fatherName),
      ],
    );
  }
}

class _SelectionItem extends StatelessWidget {
  const _SelectionItem({
    required this.label,
    required this.onTap,
    this.isDropdown = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDropdown;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral200),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              isDropdown ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_down, // Placeholder for chevron
              color: AppColors.neutral400,
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.neutral700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  const _SuggestionItem({
    required this.name,
    required this.year,
    required this.onTap,
  });

  final String name;
  final String year;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.neutral100)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'هل تقصد',
              style: TextStyle(fontSize: 10.sp, color: AppColors.neutral400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  year,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
                ),
                SizedBox(width: 8.w),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor900,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$label :',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.neutral400,
            ),
          ),
        ],
      ),
    );
  }
}
