import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:parcial_2/core/common/widgets/loader.dart';
import 'package:parcial_2/core/theme/app_pallete.dart';
import 'package:parcial_2/core/utils/pick_image.dart';
import 'package:parcial_2/core/utils/show_snackbar.dart';
import 'package:parcial_2/features/posts/presentation/bloc/entry_bloc.dart';
import 'package:parcial_2/features/posts/presentation/widgets/entry_editor.dart';

class AddEntryPage extends StatefulWidget {
  static const String name = '/add_entry';
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<File> images = [];
  int currentImageIndex = 0;

  void selectImages() async {
    final pickedImages = await pickImages();
    if (pickedImages != null) {
      setState(() {
        images.addAll(pickedImages);
      });
    }
  }

  void uploadEntry() {
    if (formKey.currentState!.validate() && images.isNotEmpty) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<EntryBloc>().add(
            EntryUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              images: images,
            ),
          );
    }
  }

  void deleteImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: uploadEntry,
          ),
        ],
      ),
      body: BlocConsumer<EntryBloc, EntryState>(
        listener: (context, state) {
          if (state is EntryFailure) {
            showSnackBar(context, state.message);
          } else if (state is EntryUploadSuccess) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          if (state is EntryLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    images.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  itemCount: images.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentImageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => deleteImage(index),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                images[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const Positioned(
                                            top: 5,
                                            right: 5,
                                            child: Icon(
                                              Icons.delete,
                                              color: AppPallete.errorColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(images.length, (index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == currentImageIndex
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text('Select images', style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 15),
                    EntryEditor(
                      controller: titleController,
                      hintText: 'Title',
                    ),
                    const SizedBox(height: 15),
                    EntryEditor(
                      controller: contentController,
                      hintText: 'Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
