import 'package:challenges_taski/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('should initialize correctly', () {
      final user = User(
        email: 'test@example.com',
        name: 'Test User',
        uuid: '12345',
      );

      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.uuid, '12345');
    });

    test('should convert to JSON correctly', () {
      final user = User(
        email: 'test@example.com',
        name: 'Test User',
        uuid: '12345',
      );

      final json = user.toJson();

      expect(json, {
        'email': 'test@example.com',
        'name': 'Test User',
        'uuid': '12345',
      });
    });

    test('should create User from JSON correctly', () {
      final json = {
        'email': 'test@example.com',
        'name': 'Test User',
        'uuid': '12345',
      };

      final user = User.fromJson(json);

      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.uuid, '12345');
    });

    test('should throw error if required fields are missing', () {
      final jsonMissingEmail = {
        'name': 'Test User',
        'uuid': '12345',
      };

      final jsonMissingName = {
        'email': 'test@example.com',
        'uuid': '12345',
      };

      final jsonMissingUuid = {
        'email': 'test@example.com',
        'name': 'Test User',
      };

      expect(() => User.fromJson(jsonMissingEmail), throwsA(isA<TypeError>()));
      expect(() => User.fromJson(jsonMissingName), throwsA(isA<TypeError>()));
      expect(() => User.fromJson(jsonMissingUuid), throwsA(isA<TypeError>()));
    });
  });
}
