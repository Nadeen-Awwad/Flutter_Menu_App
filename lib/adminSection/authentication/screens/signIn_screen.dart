import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/authentication/auth_bloc.dart';
import '../../blocs/authentication/auth_event.dart';
import '../../blocs/authentication/auth_state.dart';
import '../widgets/custom_auth_screen.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return CustomAuthScreen(
          title: "Welcome Back!",
          actionButtonText: "Sign In",
          onActionPressed: () {
            context.read<AuthBloc>().add(
              SignInEvent(emailController.text, passwordController.text),
            );
          },
          toggleText: "Don't have an account? Sign Up",
          onTogglePressed: () {
            Navigator.pushReplacementNamed(context, "/signup");
          },
          emailController: emailController,
          passwordController: passwordController,
          isLoading: state is AuthLoading,
        );
      },
    );
  }
}
