import 'package:flutter/material.dart';
import 'lib/presentation/widgets/form_controls/image_upload_field.dart';
import 'dart:io';

void main() {
  runApp(const ImageUploadTestApp());
}

class ImageUploadTestApp extends StatelessWidget {
  const ImageUploadTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ImageUploadTestPage(),
    );
  }
}

class ImageUploadTestPage extends StatefulWidget {
  const ImageUploadTestPage({super.key});

  @override
  State<ImageUploadTestPage> createState() => _ImageUploadTestPageState();
}

class _ImageUploadTestPageState extends State<ImageUploadTestPage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Test the Image Upload Field with Real Image Picker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ImageUploadField(
              label: 'Upload an Image',
              hint: 'Try selecting from camera or gallery',
              height: 250,
              onImageSelected: (file) {
                setState(() {
                  _selectedImage = file;
                });
                if (file != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Image selected: ${file.path.split('/').last}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              onImageRemoved: () {
                setState(() {
                  _selectedImage = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image removed!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ Image Successfully Selected!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Path: ${_selectedImage!.path}'),
                    Text('Name: ${_selectedImage!.path.split('/').last}'),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  'No image selected yet. Try the upload field above!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
