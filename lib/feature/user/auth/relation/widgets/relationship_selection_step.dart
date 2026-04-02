import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import 'selection_item.dart';

class RelationshipSelectionStep extends StatefulWidget {
  const RelationshipSelectionStep({
    super.key,
    required this.onSelected,
  });

  final Function(String) onSelected;

  @override
  State<RelationshipSelectionStep> createState() => _RelationshipSelectionStepState();
}

class _RelationshipSelectionStepState extends State<RelationshipSelectionStep> {
  static const List<String> _options = [
    AppTexts.relationRelationshipOption1,
    AppTexts.relationRelationshipOption2,
    AppTexts.relationRelationshipOption3,
    AppTexts.relationRelationshipOption4,
    AppTexts.relationRelationshipOption5,
  ];

  String? _selected;

  Future<void> _openPicker() async {
    final selected = await showModalBottomSheet<String>(
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
              itemCount: _options.length,
              separatorBuilder: (_, __) => Divider(height: 1.h, color: AppColors.neutral100),
              itemBuilder: (context, index) {
                final option = _options[index];
                return ListTile(
                  onTap: () => Navigator.pop(context, option),
                  title: Text(
                    option,
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

    if (!mounted || selected == null) return;
    setState(() => _selected = selected);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selected ?? _options.first;

    return Column(
      children: [
        SelectionItem(
          label: displayText,
          onTap: _openPicker,
          isDropdown: true,
        ),
        SizedBox(height: 20.h),
        AppBounceButton.elevated(
          onPressed: () => widget.onSelected(displayText),
          label: AppTexts.relationConfirm,
          backgroundColor: AppColors.primaryColor700,
        ),
      ],
    );
  }
}

