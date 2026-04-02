import 'package:flutter/material.dart';
import '../../../../../core/constant/app_texts.dart';
import 'info_row.dart';

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
        InfoRow(label: AppTexts.relationVerificationRelationshipLabel, value: relationship),
        InfoRow(label: AppTexts.relationVerificationBranchLabel, value: branch),
        InfoRow(label: AppTexts.relationVerificationFatherLabel, value: fatherName),
      ],
    );
  }
}

