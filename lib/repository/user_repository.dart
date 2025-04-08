import 'dart:convert';
import 'package:echio/models/user_model.dart';
import 'package:flutter/services.dart';

class UserRepository {
  Future<User?> login(String id, String password) async {
    final String response = await rootBundle.loadString('lib/data/users.json');
    final List<dynamic> data = json.decode(response);
    final users = data.map((u) => User.fromJson(u)).toList();

    try {
      return users.firstWhere((u) => u.id == id && u.password == password);
    } catch (e) {
      return null;
    }
  }
}
