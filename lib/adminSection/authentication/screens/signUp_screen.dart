import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/auth_bloc.dart';
import '../../blocs/authentication/auth_event.dart';
import '../../blocs/authentication/auth_state.dart';
import '../widgets/custom_auth_screen.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(

      builder: (context, state) {
        return CustomAuthScreen(
          title: "Create Account",
          actionButtonText: "Sign Up",
          onActionPressed: () {
            context.read<AuthBloc>().add(
                  SignUpEvent(emailController.text, passwordController.text),
                );
          },
          toggleText: "Already have an account? Sign In",
          onTogglePressed: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
          emailController: emailController,
          passwordController: passwordController,
          isLoading: state is AuthLoading,
        );
      },
    );
  }
}
