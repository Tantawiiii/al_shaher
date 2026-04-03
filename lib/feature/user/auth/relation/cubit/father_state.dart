import 'package:flutter/foundation.dart';

import '../../register/data/models/member_model.dart';

enum FatherLoadStatus { initial, loading, success, failure }

@immutable
class FatherState {
  const FatherState({
    this.loadStatus = FatherLoadStatus.initial,
    this.members = const [],
    this.branchId,
    this.errorMessage,
  });

  final FatherLoadStatus loadStatus;
  final List<MemberModel> members;
  final int? branchId;
  final String? errorMessage;

  FatherState copyWith({
    FatherLoadStatus? loadStatus,
    List<MemberModel>? members,
    int? branchId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FatherState(
      loadStatus: loadStatus ?? this.loadStatus,
      members: members ?? this.members,
      branchId: branchId ?? this.branchId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
