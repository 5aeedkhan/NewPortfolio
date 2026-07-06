import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/services/image_service.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _titlesController = TextEditingController();
  final PortfolioService _portfolioService = PortfolioService();
  final ImageService _imageService = ImageService();

  String? _profileImageUrl;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _titlesController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _portfolioService.getProfileData();
      if (!mounted) return;
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _titleController.text = data['title'] ?? '';
          _profileImageUrl = data['profileImageUrl'];
          if (data['titles'] != null) {
            _titlesController.text = (data['titles'] as List).join(', ');
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error loading profile data');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() => _isUploading = true);
        final bytes = await image.readAsBytes();
        final imageUrl = await _imageService.uploadImageBytes(bytes);
        if (!mounted) return;
        setState(() {
          _profileImageUrl = imageUrl;
          _isUploading = false;
        });
        _showSuccessSnackBar('Image uploaded successfully');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      _showErrorSnackBar('Error uploading image: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _portfolioService.updateProfileData({
          'name': _nameController.text.trim(),
          'title': _titleController.text.trim(),
          'titles': _titlesController.text
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList(),
          'profileImageUrl': _profileImageUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        });
        if (!mounted) return;
        _showSuccessSnackBar('Profile updated successfully');
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar('Error updating profile: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: GoogleFonts.inter(color: AppTheme.textPrimary)),
        backgroundColor: AppTheme.bgCardLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: GoogleFonts.inter(color: AppTheme.textPrimary)),
        backgroundColor: AppTheme.bgCardLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppTheme.neonPink.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  InputDecoration _darkInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
      prefixIcon: Icon(icon, color: AppTheme.neonCyan),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppTheme.neonCyan.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: AppTheme.bgCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.neonCyan,
                      width: 3,
                    ),
                    boxShadow: AppTheme.neonGlow(
                      color: AppTheme.neonCyan,
                      blurRadius: 15,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 58,
                    backgroundColor: AppTheme.bgElevated,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _profileImageUrl == null
                        ? const Icon(Icons.person, size: 60, color: AppTheme.textSecondary)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                if (_isUploading)
                  CircularProgressIndicator(color: AppTheme.neonCyan)
                else
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: Text('Change Profile Image',
                        style: GoogleFonts.inter(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonCyan,
                      foregroundColor: AppTheme.bgDarkest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Full Name',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Enter your full name', Icons.person),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Professional Title',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Enter your professional title', Icons.work),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your professional title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Typewriter Titles (comma-separated)',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titlesController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Flutter Developer, UI/UX Enthusiast, ...', Icons.title),
            maxLines: 2,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.neonCyan,
                foregroundColor: AppTheme.bgDarkest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: AppTheme.bgDarkest)
                  : Text(
                      'Save Profile',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
