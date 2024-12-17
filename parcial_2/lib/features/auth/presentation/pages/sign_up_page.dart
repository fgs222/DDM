import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/core/common/widgets/loader.dart';
import 'package:parcial_2/core/utils/show_snackbar.dart';
import 'package:parcial_2/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_pallete.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  static const String name = '/sign_up';
  
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthSuccess) {
                context.go('/home');
              } else if(state is AuthFailure) {
                showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              if(state is AuthLoading) {
                return const Loader();
              }
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 30),
                    AuthField(hintText: "User", controller: nameController),
                    const SizedBox(height: 15),
                    AuthField(hintText: "Email", controller: emailController),
                    const SizedBox(height: 15),
                    AuthField(hintText: "Password", controller: passwordController, isObscureText: true),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: 'Sign Up',
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthSignUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              name: nameController.text.trim()
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        context.go('/sign_in');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}