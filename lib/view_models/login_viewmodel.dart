import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/api_client.dart';
import '../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthRepository _repo = AuthRepository();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return "Username is required";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    return null;
  }

  Future<bool> login() async {
    final user = usernameController.text.trim();
    final pass = passwordController.text.trim();

    if (validateUsername(user) != null || validatePassword(pass) != null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final loginModel = await _repo.login(user, pass);

      if (loginModel.status == true && loginModel.token != null) {
        final box = Hive.box("app");
        await box.put("token", loginModel.token);
        await box.put("user", loginModel.userDetails?.toJson());

        ApiClient().init();

        return true; // ✅ success
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
