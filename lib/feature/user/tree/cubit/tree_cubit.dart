import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_user_model.dart';
import '../data/tree_member_model.dart';
import '../data/tree_remote_data_source.dart';
import 'tree_state.dart';

class TreeCubit extends Cubit<TreeState> {
  TreeCubit(this._remote) : super(const TreeState());

  final TreeRemoteDataSource _remote;

  /// All roots before filtering.
  List<TreeMemberModel> _allRoots = [];

  Future<void> loadTree() async {
    emit(state.copyWith(status: TreeStatus.loading, clearError: true));
    try {
      final treeResult = _remote.fetchTree();
      final userResult = _remote.fetchCurrentUser();
      final results = await Future.wait([treeResult, userResult]);

      final roots = results[0] as List<TreeMemberModel>;
      final user = results[1] as AuthUserModel;

      _allRoots = roots;

      emit(state.copyWith(
        status: TreeStatus.loaded,
        roots: roots,
        currentUser: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TreeStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void search(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(roots: _allRoots, searchQuery: ''));
      return;
    }
    final filtered = _filterTree(_allRoots, trimmed);
    emit(state.copyWith(roots: filtered, searchQuery: trimmed));
  }


  List<TreeMemberModel> _filterTree(
    List<TreeMemberModel> nodes,
    String query,
  ) {
    final result = <TreeMemberModel>[];
    for (final node in nodes) {
      final filteredChildren = _filterTree(node.children, query);
      final nameMatches =
          node.name.toLowerCase().contains(query.toLowerCase());
      if (nameMatches || filteredChildren.isNotEmpty) {
        result.add(TreeMemberModel(
          id: node.id,
          name: node.name,
          gender: node.gender,
          phone: node.phone,
          nationalId: node.nationalId,
          dateOfBirth: node.dateOfBirth,
          city: node.city,
          motherName: node.motherName,
          wifeName: node.wifeName,
          active: node.active,
          branch: node.branch,
          children: nameMatches ? node.children : filteredChildren,
        ));
      }
    }
    return result;
  }
}
