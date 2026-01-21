import 'package:deep_manage_app/Component/Buttons/PrimaryButton.dart';
import 'package:deep_manage_app/Component/Inputs/TextInputField.dart';
import 'package:deep_manage_app/Component/NavigationBar/CustomBottomNavigationBar.dart';
import 'package:deep_manage_app/Styles/Color.dart';
import 'package:deep_manage_app/View/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../Bloc/Authentication/AuthBloc.dart';
import '../../Bloc/Authentication/AuthEvent.dart';
import '../../Bloc/Authentication/AuthState.dart';
import '../../Styles/AppText.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
    _authBloc.add(CheckLoginStatusEvent());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print('🟢 Login button pressed - calling bloc');
      _authBloc.add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('🎧 AuthBloc listener - State changed to: ${state.runtimeType}');

        if (state is AuthSuccess) {
          print('✅ Login successful, navigating...');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const CustomBottomNavigationBar()),
                (route) => false,
          );
        }
        if (state is AuthFailure) {
          print('❌ Login failed: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: color.warningColor,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: color.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/cctv.json'),
                  const SizedBox(height: 20),

                  Text(
                    'Login',
                    style: AppText.HeadingText(),
                  ),
                  const SizedBox(height: 40),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextInputField(
                          label: 'Email',
                          controller: _emailController,
                          prefixIcon: const Icon(Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        TextInputField(
                          label: 'Password',
                          controller: _passwordController,
                          prefixIcon: const Icon(Icons.lock),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            print('🔵 BlocBuilder - Current state: ${state.runtimeType}');

                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: PrimaryButton(
                                text: state is AuthLoading
                                    ? "Signing In..."
                                    : "Sign In",
                                onPressed: state is AuthLoading
                                    ? null
                                    : _handleLogin, // Use the extracted method
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}