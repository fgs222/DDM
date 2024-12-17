import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> downloadImageAsFile(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageUrl);
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } else {
    throw Exception('Failed to load image');
  }
}
