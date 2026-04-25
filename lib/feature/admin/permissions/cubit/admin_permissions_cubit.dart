import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/admin_permissions_remote_data_source.dart';
import 'admin_permissions_state.dart';

class AdminPermissionsCubit extends Cubit<AdminPermissionsState> {
  AdminPermissionsCubit(this._remote) : super(const AdminPermissionsState());

  final AdminPermissionsRemoteDataSource _remote;

  Future<void> loadAdmins({bool refresh = false}) async {
    if (isClosed) return;
    if (refresh) {
      emit(state.copyWith(
        status: AdminPermissionsStatus.loading,
        currentPage: 1,
        clearError: true,
      ));
    } else {
      if (state.status == AdminPermissionsStatus.loading || state.isLoadingMore) return;
      if (state.status == AdminPermissionsStatus.loaded && state.hasReachedMax) return;

      if (state.status == AdminPermissionsStatus.loaded) {
        emit(state.copyWith(isLoadingMore: true, clearError: true));
      } else {
        emit(state.copyWith(status: AdminPermissionsStatus.loading, clearError: true));
      }
    }

    try {
      final response = await _remote.fetchAdmins(page: refresh ? 1 : (state.status == AdminPermissionsStatus.loaded ? state.currentPage + 1 : 1));
      
      if (!isClosed) {
        emit(state.copyWith(
          status: AdminPermissionsStatus.loaded,
          admins: refresh ? response.admins : [...state.admins, ...response.admins],
          currentPage: response.currentPage,
          lastPage: response.lastPage,
          total: response.total,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: state.admins.isEmpty ? AdminPermissionsStatus.error : AdminPermissionsStatus.loaded,
          isLoadingMore: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> toggleSuperAdmin(int adminId) async {
    if (isClosed) return;
    emit(state.copyWith(actionLoading: true, clearError: true));
    try {
      await _remote.toggleSuperAdmin(adminId);
      
      // Update local state for immediate feedback
      final updatedAdmins = state.admins.map((admin) {
        if (admin.id == adminId) {
          return admin.copyWith(superAdmin: !admin.superAdmin);
        }
        return admin;
      }).toList();

      if (!isClosed) {
        emit(state.copyWith(
          admins: updatedAdmins,
          actionLoading: false,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          actionLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }
}
