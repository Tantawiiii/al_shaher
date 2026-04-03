import 'package:flutter/foundation.dart';

import '../data/auth_user_model.dart';
import '../data/tree_member_model.dart';

enum TreeStatus { initial, loading, loaded, error }

@immutable
class TreeState {
  const TreeState({
    this.status = TreeStatus.initial,
    this.roots = const [],
    this.currentUser,
    this.errorMessage,
    this.searchQuery = '',
  });

  final TreeStatus status;
  final List<TreeMemberModel> roots;
  final AuthUserModel? currentUser;
  final String? errorMessage;
  final String searchQuery;

  TreeState copyWith({
    TreeStatus? status,
    List<TreeMemberModel>? roots,
    AuthUserModel? currentUser,
    String? errorMessage,
    String? searchQuery,
    bool clearError = false,
  }) {
    return TreeState(
      status: status ?? this.status,
      roots: roots ?? this.roots,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
