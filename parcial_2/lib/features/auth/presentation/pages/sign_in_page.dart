import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/core/common/widgets/loader.dart';
import 'package:parcial_2/core/utils/show_snackbar.dart';
import 'package:parcial_2/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_pallete.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';
import '../widgets/google_sign_button.dart';

class SignInPage extends StatefulWidget {
  static const String name = '/sign_in';
  const SignInPage({
    super.key,
  });

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
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
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccess) {
                context.go('/home');
              } else if (state is AuthNotLoggedIn) {
                context.go('/sign_in');
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
        
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 30),
                    AuthField(hintText: "Email", controller: emailController),
                    const SizedBox(height: 15),
                    AuthField(hintText: "Password", controller: passwordController, isObscureText: true),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: 'Sign In',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthLogin(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        }
                      }
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        context.go('/sign_up',);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GoogleSignButton(
                      auth: _auth,
                      onSignIn: (String idToken) {
                        context.read<AuthBloc>().add(AuthGoogleSignIn(idToken));
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ),
      )
    );
  }
}