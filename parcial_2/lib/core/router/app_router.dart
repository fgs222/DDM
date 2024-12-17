import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:parcial_2/features/auth/data/models/user_model.dart';
import 'package:parcial_2/features/posts/data/models/entry_model.dart';
import 'package:parcial_2/features/posts/data/datasources/entry_remote_data_source.dart';
import 'package:parcial_2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:parcial_2/features/posts/presentation/pages/add_entry_page.dart';
import 'package:parcial_2/features/posts/presentation/pages/edit_entry_page.dart';
import 'package:parcial_2/features/posts/presentation/pages/entry_viewer_page.dart';
import 'package:parcial_2/features/posts/presentation/pages/home_page.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final authBloc = context.read<AuthBloc>();
        final isLoggedIn = authBloc.state is AuthIsUserLoggedIn;

         if (isLoggedIn) {
          return FutureBuilder<UserModel?>(
            future: context.read<AuthRemoteDataSource>().getCurrentUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (!snapshot.hasData) {
                return const SignInPage();
              } else {
                final username = snapshot.data!.name;
                return HomePage(username: username);
              }
            },
          );
        } else {
          return const SignInPage();
        }
      },
    ),
    GoRoute(
      path: '/sign_in',
      name: SignInPage.name,
      builder:(context, state) => const SignInPage(),
      ),
    GoRoute(
      path: '/sign_up',
      name: SignUpPage.name,
      builder:(context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/home',
      name: HomePage.name,
       builder: (context, state) {
         return FutureBuilder<UserModel>(
          future: AuthRemoteDataSourceImpl(FirebaseAuth.instance, FirebaseFirestore.instance).getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Entry not found'));
            } else {
              final username = snapshot.data!.name;
              return HomePage(username: username);
            }
          }
        );
      },
    ),
    GoRoute(
      path: '/add_entry',
      name: AddEntryPage.name,
      builder:(context, state) => const AddEntryPage(),
    ),
    GoRoute(
      path: '/entry_viewer/:entryId',
      name: EntryViewerPage.name,
      builder: (context, state) {
        final entryId = state.pathParameters['entryId'];
         return FutureBuilder<EntryModel>(
          future: EntryRemoteDataSourceImpl(FirebaseFirestore.instance).getEntry(entryId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Entry not found'));
            } else {
              final entry = snapshot.data!;
              return EntryViewerPage(entry: entry);
            }
          }
        );
      },
    ),
    GoRoute(
      path: '/edit_entry/:entryId',
      name: EditEntryPage.name,
      builder: (context, state) {
        final entryId = state.pathParameters['entryId'];
         return FutureBuilder<EntryModel>(
          future: EntryRemoteDataSourceImpl(FirebaseFirestore.instance).getEntry(entryId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Entry not found'));
            } else {
              final entry = snapshot.data!;
              return EditEntryPage(entry: entry);
            }
          }
        );
      },
    ),
  ],
);