import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/project_service.dart';
import '../services/image_service.dart';
import 'package:portfolio/theme/app_theme.dart';

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
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.projectData['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.projectData['description'] ?? '');
    _githubUrlController = TextEditingController(text: widget.projectData['githubUrl'] ?? '');
    _youtubeUrlController = TextEditingController(text: widget.projectData['youtubeUrl'] ?? '');
    _technologiesController = TextEditingController(text: (widget.projectData['technologies'] as List?)?.join(', ') ?? '');
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
        setState(() => _selectedImageBytes = bytes);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e', style: GoogleFonts.inter(color: AppTheme.textPrimary)),
          backgroundColor: AppTheme.bgCardLight,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project updated successfully!', style: GoogleFonts.inter(color: AppTheme.textPrimary)),
            backgroundColor: AppTheme.bgCardLight,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
            ),
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', style: GoogleFonts.inter(color: AppTheme.textPrimary)),
            backgroundColor: AppTheme.bgCardLight,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
      hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
      prefixIcon: Icon(icon, size: 20, color: AppTheme.neonCyan),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.glassBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.glassBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.6), width: 1.5)),
      filled: true,
      fillColor: AppTheme.bgCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit Project',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Update your project details',
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _inputDecoration('Title', 'Enter project title', Icons.title),
            validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary, height: 1.5),
            decoration: _inputDecoration('Description', 'Describe your project in detail...', Icons.description),
            maxLines: 6,
            minLines: 3,
            validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.glassBorder),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.bgCard,
            ),
            child: Column(
              children: [
                if (_selectedImageBytes != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.memory(_selectedImageBytes!, height: 150, fit: BoxFit.contain),
                  )
                else if (_existingImageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.network(_existingImageUrl!, height: 150, fit: BoxFit.contain),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.image, size: 18),
                    label: Text(
                      _selectedImageBytes == null ? 'Change Image' : 'Replace Image',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonCyan,
                      foregroundColor: AppTheme.bgDarkest,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _technologiesController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _inputDecoration('Technologies', 'Flutter, Firebase, Dart', Icons.code),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _playStoreUrlController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _inputDecoration('Playstore URL', 'https://play.google.com/..', Icons.link),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _githubUrlController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _inputDecoration('GitHub URL', 'https://github.com/..', Icons.code),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _youtubeUrlController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _inputDecoration('YouTube URL', 'https://youtube.com/..', Icons.play_circle_outline),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppTheme.neonCyan,
              foregroundColor: AppTheme.bgDarkest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isLoading
                ? CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bgDarkest))
                : Text('Update Project', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
