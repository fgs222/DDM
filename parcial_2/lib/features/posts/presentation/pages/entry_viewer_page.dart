import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_2/core/common/widgets/loader.dart';
import 'package:parcial_2/core/theme/app_pallete.dart';
import 'package:parcial_2/features/posts/domain/entities/entry.dart';

class EntryViewerPage extends StatelessWidget {
  static const String name = '/entry_viewer';
  final Entry entry;
  const EntryViewerPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Entry'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/edit_entry/${entry.id}');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.whiteColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              entry.imageUrls.isNotEmpty
                  ? SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: entry.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                    entry.imageUrls[index],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) =>
                                        loadingProgress == null
                                            ? child
                                            : const Loader(),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${index + 1}/${entry.imageUrls.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 12),
              Text(
                entry.content,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppPallete.whiteColor,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
