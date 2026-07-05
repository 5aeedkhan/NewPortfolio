import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/project_service.dart';
import '../services/image_service.dart';
import 'package:portfolio/theme/app_theme.dart';

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e',
              style: GoogleFonts.inter(color: AppTheme.textPrimary)),
          backgroundColor: AppTheme.bgCardLight,
        ),
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
            SnackBar(
              content: Text('Project added successfully!',
                  style: GoogleFonts.inter(color: AppTheme.textPrimary)),
              backgroundColor: AppTheme.bgCardLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
              ),
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() => _uploadError = e.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e',
                  style: GoogleFonts.inter(color: AppTheme.textPrimary)),
              backgroundColor: AppTheme.bgCardLight,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image',
              style: GoogleFonts.inter(color: AppTheme.textPrimary)),
          backgroundColor: AppTheme.bgCardLight,
        ),
      );
    }
  }

  InputDecoration _darkInputDecoration(String label, String hint, IconData icon) {
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            'Add New Project',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Share your amazing work',
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Title', 'Enter project title', Icons.title),
            validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary, height: 1.5),
            decoration: _darkInputDecoration('Description', 'Describe your project in detail...', Icons.description),
            maxLines: 6,
            minLines: 3,
            validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
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
                if (_selectedImageBytes != null) ...[
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      border: Border(bottom: BorderSide(color: AppTheme.glassBorder)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.memory(_selectedImageBytes!, fit: BoxFit.contain),
                    ),
                  ),
                ],
                if (_uploadError != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(_uploadError!, style: GoogleFonts.inter(color: AppTheme.neonPink, fontSize: 12), textAlign: TextAlign.center),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.image, size: 18),
                    label: Text(_selectedImageBytes == null ? 'Select Image' : 'Change Image', style: GoogleFonts.inter(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonCyan,
                      foregroundColor: AppTheme.bgDarkest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            decoration: _darkInputDecoration('Technologies', 'Flutter, Firebase, Dart', Icons.code),
            validator: (value) => value == null || value.isEmpty ? 'Please enter technologies' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _playStoreUrlController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Playstore URL', 'https://play.google.com/store/apps/details?id=...', Icons.link),
            validator: (value) {
              if (value != null && value.isNotEmpty && !value.startsWith('http://') && !value.startsWith('https://')) {
                return 'URL must start with http:// or https://';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _githubUrlController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('GitHub URL', 'https://github.com/username/repo', Icons.code),
            validator: (value) {
              if (value != null && value.isNotEmpty && !value.startsWith('http://') && !value.startsWith('https://')) {
                return 'URL must start with http:// or https://';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _youtubeUrlController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('YouTube URL', 'https://youtube.com/watch?v=...', Icons.play_circle_outline),
            validator: (value) {
              if (value != null && value.isNotEmpty && !value.startsWith('http://') && !value.startsWith('https://')) {
                return 'URL must start with http:// or https://';
              }
              return null;
            },
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
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bgDarkest)),
                  )
                : Text('Add Project', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
