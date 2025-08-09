import 'package:flutter/material.dart';
import 'dart:io';
import 'image_upload_field.dart';

class ImageUploadDemo extends StatefulWidget {
  const ImageUploadDemo({super.key});

  @override
  State<ImageUploadDemo> createState() => _ImageUploadDemoState();
}

class _ImageUploadDemoState extends State<ImageUploadDemo> {
  File? _profileImage;
  File? _documentImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ImageUploadField(
            label: 'Profile Picture',
            hint: 'Upload your profile picture from camera or gallery',
            height: 200,
            onImageSelected: (file) {
              setState(() {
                _profileImage = file;
              });
              if (file != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile image selected!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            onImageRemoved: () {
              setState(() {
                _profileImage = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile image removed!'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ImageUploadField(
            label: 'Document Upload',
            hint: 'Upload a document or certificate',
            height: 150,
            onImageSelected: (file) {
              setState(() {
                _documentImage = file;
              });
              if (file != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document uploaded!'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            onImageRemoved: () {
              setState(() {
                _documentImage = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Document removed!'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          if (_profileImage != null || _documentImage != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 20, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Upload Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_profileImage != null)
                    Row(
                      children: [
                        const Icon(Icons.account_circle,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Profile: ${_profileImage!.path.split('/').last}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  if (_documentImage != null) ...[
                    if (_profileImage != null) const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.description,
                            size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Document: ${_documentImage!.path.split('/').last}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
