import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/services/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
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
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await _portfolioService.getProfileData();
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? 'Muhammad Saeed Khan';
          _titleController.text = data['title'] ?? 'Mobile App Developer';
          _profileImageUrl = data['profileImageUrl'];
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error loading profile data');
    } finally {
      setState(() => _isLoading = false);
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
        
        final imageUrl = await _imageService.uploadImage(File(image.path));
        
        setState(() {
          _profileImageUrl = imageUrl;
          _isUploading = false;
        });
        
        _showSuccessSnackBar('Image uploaded successfully');
      }
    } catch (e) {
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
          'profileImageUrl': _profileImageUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        });

        _showSuccessSnackBar('Profile updated successfully');
        Navigator.pop(context);
      } catch (e) {
        _showErrorSnackBar('Error updating profile: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Section
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _profileImageUrl == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                if (_isUploading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Change Profile Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Name Field
          Text(
            'Full Name',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(),
          
          const SizedBox(height: 8),
          
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 100)),

          const SizedBox(height: 20),

          // Title Field
          Text(
            'Professional Title',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 200)),
          
          const SizedBox(height: 8),
          
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter your professional title',
              prefixIcon: const Icon(Icons.work),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your professional title';
              }
              return null;
            },
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 300)),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Save Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ).animate().fadeIn().slideY(delay: const Duration(milliseconds: 400)),
          ),
        ],
      ),
    );
  }
}
