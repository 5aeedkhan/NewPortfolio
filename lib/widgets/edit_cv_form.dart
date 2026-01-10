import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/services/portfolio_service.dart';

class EditCVForm extends StatefulWidget {
  const EditCVForm({super.key});

  @override
  State<EditCVForm> createState() => _EditCVFormState();
}

class _EditCVFormState extends State<EditCVForm> {
  final _formKey = GlobalKey<FormState>();
  final _cvUrlController = TextEditingController();
  final _cvTitleController = TextEditingController();
  final PortfolioService _portfolioService = PortfolioService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCVData();
  }

  @override
  void dispose() {
    _cvUrlController.dispose();
    _cvTitleController.dispose();
    super.dispose();
  }

  Future<void> _loadCVData() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await _portfolioService.getCVData();
      if (data != null) {
        setState(() {
          _cvUrlController.text = data['cvUrl'] ?? '';
          _cvTitleController.text = data['cvTitle'] ?? 'View Full CV';
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error loading CV data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveCV() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _portfolioService.updateCVData({
          'cvUrl': _cvUrlController.text.trim(),
          'cvTitle': _cvTitleController.text.trim(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        _showSuccessSnackBar('CV information updated successfully');
        Navigator.pop(context);
      } catch (e) {
        _showErrorSnackBar('Error updating CV information: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _testCVLink() async {
    final url = _cvUrlController.text.trim();
    if (url.isEmpty) {
      _showErrorSnackBar('Please enter a CV URL first');
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch CV link. Please check the URL.');
      }
    } catch (e) {
      _showErrorSnackBar('Invalid URL format');
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
          // CV Title Field
          Text(
            'CV Button Title',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(),
          
          const SizedBox(height: 8),
          
          TextFormField(
            controller: _cvTitleController,
            decoration: InputDecoration(
              hintText: 'Enter button title (e.g., View Full CV)',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a button title';
              }
              return null;
            },
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 100)),

          const SizedBox(height: 20),

          // CV URL Field
          Text(
            'CV/Resume URL',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 200)),
          
          const SizedBox(height: 8),
          
          Text(
            'Upload your CV to Google Drive, Dropbox, or any cloud storage and paste the shareable link here.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 250)),
          
          const SizedBox(height: 8),
          
          TextFormField(
            controller: _cvUrlController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter your CV URL (Google Drive, Dropbox, etc.)',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your CV URL';
              }
              // Basic URL validation
              if (!value.startsWith('http://') && !value.startsWith('https://')) {
                return 'Please enter a valid URL starting with http:// or https://';
              }
              return null;
            },
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 300)),

          const SizedBox(height: 16),

          // Test Link Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _testCVLink,
              icon: const Icon(Icons.open_in_new),
              label: Text(
                'Test CV Link',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 350)),
          ),

          const SizedBox(height: 24),

          // Instructions Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'How to get your CV link:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...[
                  '1. Upload your CV to Google Drive or Dropbox',
                  '2. Right-click on the file and select "Share"',
                  '3. Change sharing settings to "Anyone with the link"',
                  '4. Copy the shareable link',
                  '5. Paste the link in the field above'
                ].map((instruction) => Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 28),
                  child: Text(
                    instruction,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blue.shade600,
                    ),
                  ),
                )),
              ],
            ),
          ).animate().fadeIn().slideY(delay: const Duration(milliseconds: 400)),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveCV,
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
                      'Save CV Information',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ).animate().fadeIn().slideY(delay: const Duration(milliseconds: 500)),
          ),
        ],
      ),
    );
  }
}
