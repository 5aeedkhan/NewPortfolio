import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/project_service.dart';
import '../services/image_service.dart';

class EditProjectForm extends StatefulWidget {
  final String projectId;
  final Map<String, dynamic> projectData;

  const EditProjectForm({
    super.key,
    required this.projectId,
    required this.projectData,
  });

  @override
  State<EditProjectForm> createState() => _EditProjectFormState();
}

class _EditProjectFormState extends State<EditProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _projectService = ProjectService();
  final _imageService = ImageService();
  final _imagePicker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _githubUrlController;
  late TextEditingController _youtubeUrlController;
  late TextEditingController _technologiesController;
  late TextEditingController _playStoreUrlController;

  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  String? _uploadError;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.projectData['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.projectData['description'] ?? '');
    _githubUrlController = TextEditingController(text: widget.projectData['githubUrl'] ?? '');
    _youtubeUrlController = TextEditingController(text: widget.projectData['youtubeUrl'] ?? '');
    _technologiesController = TextEditingController(
      text: (widget.projectData['technologies'] as List?)?.join(', ') ?? '',
    );
    _playStoreUrlController = TextEditingController(text: widget.projectData['playStoreUrl'] ?? '');
    _existingImageUrl = widget.projectData['imageUrl'];
  }

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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _uploadError = null;
      });

      try {
        String imageUrl = _existingImageUrl ?? '';
        if (_selectedImageBytes != null) {
          imageUrl = await _imageService.uploadImageBytes(_selectedImageBytes!);
        }

        await _projectService.updateProject(
          projectId: widget.projectId,
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: imageUrl,
          technologies: _technologiesController.text.split(',').map((e) => e.trim()).toList(),
          githubUrl: _githubUrlController.text,
          youtubeUrl: _youtubeUrlController.text,
          playStoreUrl: _playStoreUrlController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project updated successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() => _uploadError = e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
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
              'Edit Project',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Update your project details',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration('Title', 'Enter project title', Icons.title),
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 12),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: _inputDecoration('Description', 'Describe your project in detail...', Icons.description),
              maxLines: 6,
              minLines: 3,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                height: 1.5,
              ),
              validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 12),

            // Image
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  if (_selectedImageBytes != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.memory(_selectedImageBytes!, height: 150, fit: BoxFit.cover),
                    )
                  else if (_existingImageUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.network(_existingImageUrl!, height: 150, fit: BoxFit.cover),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickImage,
                      icon: const Icon(Icons.image, size: 18),
                      label: Text(
                        _selectedImageBytes == null ? 'Change Image' : 'Replace Image',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Technologies
            TextFormField(
              controller: _technologiesController,
              decoration: _inputDecoration('Technologies', 'Flutter, Firebase, Dart', Icons.code),
            ),
            const SizedBox(height: 12),

            // Playstore
            TextFormField(
              controller: _playStoreUrlController,
              decoration: _inputDecoration('Playstore URL', 'https://play.google.com/..', Icons.link),
            ),
            const SizedBox(height: 12),

            // GitHub
            TextFormField(
              controller: _githubUrlController,
              decoration: _inputDecoration('GitHub URL', 'https://github.com/..', Icons.code),
            ),
            const SizedBox(height: 12),

            // YouTube
            TextFormField(
              controller: _youtubeUrlController,
              decoration: _inputDecoration('YouTube URL', 'https://youtube.com/..', Icons.play_circle_outline),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text('Update Project', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}
