import 'package:flutter/foundation.dart';

enum RegisterStatus {
  initial,
  uploadingImage,
  submittingApplication,
  success,
  failure,
}

@immutable
class RegisterState {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.name = '',
    this.nationalId = '',
    this.phone = '',
    this.dateOfBirthIso = '',
    this.city = '',
    this.password = '',
    this.gender,
    this.imageId,
    this.personalRelationships = const [],
    this.branchId,
    this.fatherId,
  });

  final RegisterStatus status;
  final String? errorMessage;

  final String name;
  final String nationalId;
  final String phone;
  final String dateOfBirthIso;
  final String city;
  final String password;
  final String? gender;

  final int? imageId;
  final List<String> personalRelationships;
  final int? branchId;
  final int? fatherId;

  bool get hasStepOneComplete =>
      name.isNotEmpty &&
      nationalId.isNotEmpty &&
      phone.isNotEmpty &&
      city.isNotEmpty &&
      password.isNotEmpty &&
      imageId != null;

  bool get canSubmitApplication =>
      hasStepOneComplete &&
      personalRelationships.isNotEmpty &&
      branchId != null &&
      fatherId != null;

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    String? name,
    String? nationalId,
    String? phone,
    String? dateOfBirthIso,
    String? city,
    String? password,
    Object? gender = _noValue,
    int? imageId,
    List<String>? personalRelationships,
    int? branchId,
    int? fatherId,
    bool clearError = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      name: name ?? this.name,
      nationalId: nationalId ?? this.nationalId,
      phone: phone ?? this.phone,
      dateOfBirthIso: dateOfBirthIso ?? this.dateOfBirthIso,
      city: city ?? this.city,
      password: password ?? this.password,
      gender: identical(gender, _noValue) ? this.gender : gender as String?,
      imageId: imageId ?? this.imageId,
      personalRelationships:
          personalRelationships ?? this.personalRelationships,
      branchId: branchId ?? this.branchId,
      fatherId: fatherId ?? this.fatherId,
    );
  }
}

const Object _noValue = Object();
