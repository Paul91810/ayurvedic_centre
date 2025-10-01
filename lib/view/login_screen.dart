import 'package:ayurvedic_centre/view/home_screen.dart';
import 'package:ayurvedic_centre/view_models/login_viewmodel.dart';
import 'package:ayurvedic_centre/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/custom_button.dart';
import '../../theme/theme_provider.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginVM = Provider.of<LoginViewModel>(context);
    final size = MediaQuery.of(context).size;

    final _formKey = GlobalKey<FormState>();

    return ResponsiveScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                height: size.height * 0.18,
                child: Image.asset("assets/images/logo.png"),
              ),
              const SizedBox(height: 30),

              // Username
              CustomTextField(
                controller: loginVM.usernameController,
                label: "Username",
                validator: loginVM.validateUsername,
              ),
              const SizedBox(height: 20),

              // Password
              CustomTextField(
                controller: loginVM.passwordController,
                label: "Password",
                obscureText: true,
                validator: loginVM.validatePassword,
              ),
              const SizedBox(height: 25),

              // Login Button
              CustomButton(
                text: "Login",
                loading: loginVM.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await loginVM.login();
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login Success ✅")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid credentials ❌")),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 20),

              // Theme toggle
              IconButton(
                icon: Icon(themeProvider.isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => themeProvider.toggleTheme(),
              ),

              const SizedBox(height: 20),

              Text(
                "By logging in you agree to our Terms & Privacy Policy",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
