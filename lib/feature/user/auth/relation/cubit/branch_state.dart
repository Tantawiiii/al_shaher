import 'package:flutter/foundation.dart';


import '../../register/data/models/branch_model.dart';

enum BranchLoadStatus { initial, loading, success, failure }

@immutable
class BranchState {
  const BranchState({
    this.loadStatus = BranchLoadStatus.initial,
    this.branches = const [],
    this.errorMessage,
  });

  final BranchLoadStatus loadStatus;
  final List<BranchModel> branches;
  final String? errorMessage;

  BranchState copyWith({
    BranchLoadStatus? loadStatus,
    List<BranchModel>? branches,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BranchState(
      loadStatus: loadStatus ?? this.loadStatus,
      branches: branches ?? this.branches,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
