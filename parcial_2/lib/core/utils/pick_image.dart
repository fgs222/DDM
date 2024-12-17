import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<List<File>?> pickImages() async {
  try {
    final picker = ImagePicker();
    final List<XFile>? xFiles = await picker.pickMultiImage();

    if (xFiles != null && xFiles.isNotEmpty) {
      for (var xFile in xFiles) {
        print("Picked image path: ${xFile.path}");
      }

      return xFiles.map((xFile) => File(xFile.path)).toList();
    }
    return null;
  } catch (e) {
    print("Error picking images: $e");
    return null;
  }
}
