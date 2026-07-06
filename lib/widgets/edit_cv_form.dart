import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';

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
      if (!mounted) return;
      if (data != null) {
        setState(() {
          _cvUrlController.text = data['cvUrl'] ?? '';
          _cvTitleController.text = data['cvTitle'] ?? 'View Full CV';
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error loading CV data');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        if (!mounted) return;
        _showSuccessSnackBar('CV information updated successfully');
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar('Error updating CV information: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
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
      final canLaunch = await canLaunchUrl(uri);
      if (!mounted) return;
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch CV link. Please check the URL.');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Invalid URL format');
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
          Text(
            'CV Button Title',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _cvTitleController,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Enter button title (e.g., View Full CV)', Icons.title),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a button title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            'CV/Resume URL',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your CV to Google Drive, Dropbox, or any cloud storage and paste the shareable link here.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _cvUrlController,
            maxLines: 2,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: _darkInputDecoration('Enter your CV URL (Google Drive, Dropbox, etc.)', Icons.link),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your CV URL';
              }
              if (!value.startsWith('http://') && !value.startsWith('https://')) {
                return 'Please enter a valid URL starting with http:// or https://';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _testCVLink,
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(
                'Test CV Link',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: AppTheme.neonCyan,
                side: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.5), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.neonCyan.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.neonCyan, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'How to get your CV link:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.neonCyan,
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
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveCV,
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
                      'Save CV Information',
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
