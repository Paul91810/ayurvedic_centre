import 'package:ayurvedic_centre/view/home_screen.dart';
import 'package:ayurvedic_centre/widgets/page_transitions.dart';
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

  Future<bool> login(BuildContext context) async {
    final user = usernameController.text.trim();
    final pass = passwordController.text.trim();

    if (validateUsername(user) != null || validatePassword(pass) != null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final value = await _repo.login(user, pass);

      final box = Hive.box("settings");
      await box.put("token", value.token);

      ApiClient().init();

      if (value.status == true) {
        Navigator.pushReplacement(
          context,
          AppPageTransition.slideRightToLeft(const HomeScreen()),
        );

        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(value.message ?? "Login failed")),
        );
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
