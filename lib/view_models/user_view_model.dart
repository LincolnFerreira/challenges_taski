import 'package:challenges_taski/models/user.dart';
import 'package:challenges_taski/repositories/user_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepositoryImpl repository;

  User? _user;
  User? get user => _user;

  UserViewModel({required this.repository});

  Future<bool> createUser(String email, String name) async {
    final uuid = Uuid();
    final userId = uuid.v4();

    final user = User(
      email: email,
      name: name,
      uuid: userId,
    );

    try {
      final createdUser = await repository.createUser(user: user);

      _user = createdUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao criar usuário: $e');
      return false;
    }
  }

  Future<void> getCachedUser() async {
    _user = await repository.localDataSource.getCachedUser();
    notifyListeners();
  }
}
