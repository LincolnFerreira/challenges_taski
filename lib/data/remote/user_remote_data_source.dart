import 'package:challenges_taski/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final Uuid uuid = Uuid();

  UserRemoteDataSource({required this.firestore});

  Future<User> createUser(String name, String email) async {
    try {
      final String userId = uuid.v4();

      final userData = {
        'uuid': userId,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('users').doc(userId).set(userData);

      return User(
        uuid: userId,
        name: name,
        email: email,
      );
    } catch (e) {
      print('Failed to create user: $e');
      throw Exception('Failed to create user');
    }
  }
}
