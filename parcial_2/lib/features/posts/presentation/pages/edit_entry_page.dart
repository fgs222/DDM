import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/core/common/widgets/loader.dart';
import 'package:parcial_2/core/theme/app_pallete.dart';
import 'package:parcial_2/core/utils/image_as_file.dart';
import 'package:parcial_2/core/utils/pick_image.dart';
import 'package:parcial_2/core/utils/show_snackbar.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';
import 'package:parcial_2/features/posts/presentation/bloc/entry_bloc.dart';
import 'package:parcial_2/features/posts/presentation/widgets/entry_editor.dart';

class EditEntryPage extends StatefulWidget {
  static const String name = '/edit_entry';
  final Entry entry;
  const EditEntryPage({super.key, required this.entry});

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<File> imageFiles = [];
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.entry.title;
    contentController.text = widget.entry.content;
    if (widget.entry.imageUrls.isNotEmpty) {
      _loadImages(widget.entry.imageUrls);
    }
  }

  Future<void> _loadImages(List<String> imageUrls) async {
    for (var imageUrl in imageUrls) {
      final file = await downloadImageAsFile(imageUrl);
      setState(() {
        imageFiles.add(file);
      });
    }
  }

  void selectImages() async {
    final pickedImages = await pickImages();
    if (pickedImages != null) {
      setState(() {
        imageFiles.addAll(pickedImages.where((image) => !imageFiles.contains(image)));
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      imageFiles.removeAt(index);
    });
  }

  void updateEntry() {
    if (formKey.currentState!.validate()) {
      final updatedEntry = widget.entry.copyWith(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        imageUrls: imageFiles.map((file) => file.path).toList(),
      );

      context.read<EntryBloc>().add(
        EntryUpdate(entry: updatedEntry, images: imageFiles),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: updateEntry,
          ),
        ],
      ),
      body: BlocConsumer<EntryBloc, EntryState>(
        listener: (context, state) {
          if (state is EntryFailure) {
            showSnackBar(context, state.message);
          } else if (state is EntryUpdateSuccess) {
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
                    if (imageFiles.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              itemCount: imageFiles.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => selectImages(),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          imageFiles[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () => deleteImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: AppPallete.errorColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onPageChanged: (index) {
                                setState(() {
                                  currentImageIndex = index;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(imageFiles.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                      ),

                    if (imageFiles.isEmpty)
                      GestureDetector(
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
                                Text('Select your image', style: TextStyle(fontSize: 15)),
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
