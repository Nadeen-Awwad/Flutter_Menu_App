import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/adminSection/widgets/custom_text_widget.dart';

import '../../blocs/authentication/auth_bloc.dart';
import '../../blocs/authentication/auth_state.dart';
import '../../blocs/cartBloc/cart_bloc.dart';
import '../../blocs/cartBloc/cart_event.dart';

class CustomAuthScreen extends StatelessWidget {
  final String title;
  final String actionButtonText;
  final VoidCallback onActionPressed;
  final String toggleText;
  final VoidCallback onTogglePressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;

  const CustomAuthScreen({
    Key? key,
    required this.title,
    required this.actionButtonText,
    required this.onActionPressed,
    required this.toggleText,
    required this.onTogglePressed,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state is AuthSuccess) {
          context.read<CartBloc>().add(LoadCart());
          Navigator.pushReplacementNamed(context, "/home");
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            /// Background Image & Blur Effect
            Positioned.fill(
              child: Image.asset("assets/images/food.jpg", fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      text: title,
                    ),
                    SizedBox(height: 30),

                    /// Email & Password Fields
                    _buildTextField(
                        emailController, "Email", false, Icons.email),
                    _buildTextField(
                        passwordController, "Password", true, Icons.lock),

                    SizedBox(height: 20),

                    /// Action Button (Sign In / Sign Up)
                    ElevatedButton(
                      onPressed: isLoading ? null : onActionPressed,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.orange.withOpacity(0.4),
                        elevation: 5,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.orangeAccent,
                                  Colors.deepOrange
                                ],
                              ).createShader(bounds),
                              child: Text(
                                actionButtonText,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ),

                    SizedBox(height: 15),

                    /// Toggle Link (Navigate between Sign In / Sign Up)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onTogglePressed,
                        child: Text(
                          toggleText,
                          style: TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TextField Widget
  Widget _buildTextField(TextEditingController controller, String label,
      bool obscure, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orangeAccent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withOpacity(0.4),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }
}
