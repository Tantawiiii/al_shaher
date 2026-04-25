import 'package:equatable/equatable.dart';
import '../data/admin_permission_model.dart';

enum AdminPermissionsStatus { initial, loading, loaded, error }

class AdminPermissionsState extends Equatable {
  const AdminPermissionsState({
    this.status = AdminPermissionsStatus.initial,
    this.admins = const [],
    this.errorMessage,
    this.actionLoading = false,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.isLoadingMore = false,
  });

  final AdminPermissionsStatus status;
  final List<AdminPermissionModel> admins;
  final String? errorMessage;
  final bool actionLoading;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool isLoadingMore;

  bool get hasReachedMax => currentPage >= lastPage;

  AdminPermissionsState copyWith({
    AdminPermissionsStatus? status,
    List<AdminPermissionModel>? admins,
    String? errorMessage,
    bool? actionLoading,
    bool clearError = false,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? isLoadingMore,
  }) {
    return AdminPermissionsState(
      status: status ?? this.status,
      admins: admins ?? this.admins,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionLoading: actionLoading ?? this.actionLoading,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        admins,
        errorMessage,
        actionLoading,
        currentPage,
        lastPage,
        total,
        isLoadingMore,
      ];
}
