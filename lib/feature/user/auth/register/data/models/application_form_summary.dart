import 'package:flutter/foundation.dart';

import '../../cubit/register_state.dart';

/// Snapshot of the application form after successful submit (for order UI).
@immutable
class ApplicationFormSummary {
  const ApplicationFormSummary({
    required this.name,
    required this.nationalId,
    required this.phone,
    required this.dateOfBirthIso,
    required this.city,
    this.gender,
    required this.imageId,
    required this.personalRelationships,
    required this.branchId,
    required this.fatherId,
    required this.relationshipLabel,
    required this.branchName,
    required this.fatherName,
  });

  final String name;
  final String nationalId;
  final String phone;
  final String dateOfBirthIso;
  final String city;
  final String? gender;
  final int imageId;
  final List<String> personalRelationships;
  final int branchId;
  final int fatherId;
  final String relationshipLabel;
  final String branchName;
  final String fatherName;

  factory ApplicationFormSummary.fromRegisterAndLabels({
    required RegisterState register,
    required String relationshipLabel,
    required String branchName,
    required String fatherName,
  }) {
    return ApplicationFormSummary(
      name: register.name,
      nationalId: register.nationalId,
      phone: register.phone,
      dateOfBirthIso: register.dateOfBirthIso,
      city: register.city,
      gender: register.gender,
      imageId: register.imageId ?? 0,
      personalRelationships: List<String>.from(register.personalRelationships),
      branchId: register.branchId ?? 0,
      fatherId: register.fatherId ?? 0,
      relationshipLabel: relationshipLabel,
      branchName: branchName,
      fatherName: fatherName,
    );
  }

  String get relationshipsDisplay =>
      personalRelationships.isEmpty ? '—' : personalRelationships.join('، ');
}
