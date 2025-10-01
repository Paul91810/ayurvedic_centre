import 'package:ayurvedic_centre/view/home_screen.dart';
import 'package:ayurvedic_centre/view_models/login_viewmodel.dart';
import 'package:ayurvedic_centre/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey, 
          child: ListView(
            children: [
              Image.asset("assets/Frame 176.png", fit: BoxFit.fill),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login Or Register To Back Yoour Appointments",
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: loginVM.usernameController,
                      label: "Username",
                      validator: loginVM.validateUsername,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: loginVM.passwordController,
                      label: "Password",
                      obscureText: true,
                      validator: loginVM.validatePassword,
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: "Login",
                      loading: loginVM.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                         await loginVM.login(context);
                         
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      "By Creating or Logging into an account, you Agreeing with our  Terms and Conditions and Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
