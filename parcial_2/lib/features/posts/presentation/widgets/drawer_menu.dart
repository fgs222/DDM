import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parcial_2/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_pallete.dart';

class DrawerMenu extends StatelessWidget {
  final String username;

  const DrawerMenu({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppPallete.gradient1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppPallete.whiteColor,
                  child: Icon(Icons.person, size: 40, color: AppPallete.gradient1),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(
                    color: AppPallete.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.list),
          //   title: const Text('Profile'),
          //   onTap: () {
          //     // Handle profile navigation or action here
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Log out'),
            onTap: () async {
              await _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      context.read<AuthBloc>().add(AuthLoggedOut());
      context.go('/sign_in');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }
}
