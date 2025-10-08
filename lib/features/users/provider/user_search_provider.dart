import 'package:flutter/material.dart';
import 'package:mera_web/features/users/model/user_model.dart';

class UserSearchProvider extends ChangeNotifier {
  String _query = '';
  String get query => _query;

  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  // filtered list getter
  List<UserModel> get filteredUsers {
    if (_query.isEmpty) return _allUsers;
    return _allUsers
        .where((u) => u.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  // update full list when Firestore stream updates
  void setUsers(List<UserModel> users) {
    _allUsers = users;
    notifyListeners();
  }

  // update search query
  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }
}
