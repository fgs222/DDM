import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/core/theme/app_pallete.dart';
import 'package:parcial_2/core/utils/show_snackbar.dart';
import 'package:parcial_2/features/posts/presentation/bloc/entry_bloc.dart';
import 'package:parcial_2/features/posts/presentation/widgets/entry_card.dart';
import 'package:parcial_2/features/posts/presentation/widgets/drawer_menu.dart';

class HomePage extends StatefulWidget {
  static const String name = '/home';
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<EntryBloc>().add(EntryGetAllEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Open Menu',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'My Blog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled, color: AppPallete.whiteColor),
            onPressed: () {
              context.push('/add_entry');
            },
          ),
        ],
      ),
      drawer: DrawerMenu(username: widget.username),
      body: BlocConsumer<EntryBloc, EntryState>(
        listener: (context, state) {
          if (state is EntryFailure) {
            showSnackBar(context, state.message);
          }
          if (state is EntryUploadSuccess ||
              state is EntryDeleteSuccess ||
              state is EntryUpdateSuccess) {
            context.read<EntryBloc>().add(EntryGetAllEntries());
          }
        },
        builder: (context, state) {
          if (state is EntryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EntryDisplaySuccess) {
            if (state.entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.archivebox, size: 80, color: AppPallete.greyColor),
                    const SizedBox(height: 20),
                    const Text(
                      'No entries available.',
                      style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        context.push('/add_entry');
                      },
                      child: const Text(
                        'Upload your first entry!',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final entry = state.entries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: EntryCard(
                    entry: entry,
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                    entryId: entry.id,
                    onDelete: () {
                      context.read<EntryBloc>().add(EntryDeleteEntry(entryId: entry.id));
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(fontSize: 18, color: AppPallete.errorColor),
            ),
          );
        },
      ),
    );
  }
}
