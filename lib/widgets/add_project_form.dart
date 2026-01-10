import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../services/project_service.dart';
import '../services/image_service.dart';

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({super.key});

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _projectService = ProjectService();
  final _imageService = ImageService();
  final _imagePicker = ImagePicker();
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubUrlController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _playStoreUrlController = TextEditingController();

  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  String? _uploadError;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _uploadError = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedImageBytes != null) {
      setState(() {
        _isLoading = true;
        _uploadError = null;
      });
      
      try {
        final imageUrl = await _imageService.uploadImageBytes(_selectedImageBytes!);
        
        await _projectService.addProject(
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: imageUrl,
          technologies: _technologiesController.text.split(',').map((e) => e.trim()).toList(),
          githubUrl: _githubUrlController.text,
          youtubeUrl: _youtubeUrlController.text,
        );

        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _githubUrlController.clear();
        _youtubeUrlController.clear();
        _technologiesController.clear();
        setState(() => _selectedImageBytes = null);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project added successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() => _uploadError = e.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Project',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Share your amazing work',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter project title',
                prefixIcon: const Icon(Icons.title, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your project in detail...',
                prefixIcon: const Icon(Icons.description, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                filled: true,
                fillColor: Colors.grey.shade50,
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              minLines: 3,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                height: 1.5,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  if (_selectedImageBytes != null) ...[
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.memory(
                          _selectedImageBytes!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red.shade300, size: 24),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Error loading image',
                                    style: TextStyle(color: Colors.red.shade300, fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  if (_uploadError != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        _uploadError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickImage,
                      icon: const Icon(Icons.image, size: 18),
                      label: Text(
                        _selectedImageBytes == null ? 'Select Image' : 'Change Image',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _technologiesController,
              decoration: InputDecoration(
                labelText: 'Technologies',
                hintText: 'Flutter, Firebase, Dart',
                prefixIcon: const Icon(Icons.code, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter technologies';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _playStoreUrlController,
              decoration: InputDecoration(
                labelText: 'Playstore URL',
                hintText: 'https://play.google.com/store/apps/details?id=...',
                prefixIcon: const Icon(Icons.code, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
validator: (value) {
  if (value != null && value.isNotEmpty) {
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return 'URL must start with http:// or https://';
    }
  }
  return null;
},

            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _githubUrlController,
              decoration: InputDecoration(
                labelText: 'GitHub URL',
                hintText: 'https://github.com/username/repo',
                prefixIcon: const Icon(Icons.code, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
validator: (value) {
  if (value != null && value.isNotEmpty) {
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return 'URL must start with http:// or https://';
    }
  }
  return null;
},

            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                labelText: 'YouTube URL',
                hintText: 'https://youtube.com/watch?v=...',
                prefixIcon: const Icon(Icons.play_circle_outline, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
validator: (value) {
  if (value != null && value.isNotEmpty) {
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return 'URL must start with http:// or https://';
    }
  }
  return null;
},

            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Add Project',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 