import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';

class EditAboutForm extends StatefulWidget {
  const EditAboutForm({super.key});

  @override
  State<EditAboutForm> createState() => _EditAboutFormState();
}

class _EditAboutFormState extends State<EditAboutForm> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  final PortfolioService _portfolioService = PortfolioService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAboutData();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _loadAboutData() async {
    setState(() => _isLoading = true);

    try {
      final data = await _portfolioService.getAboutData();
      if (!mounted) return;
      if (data != null) {
        setState(() {
          _summaryController.text = data['summary'] ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error loading about data');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAbout() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _portfolioService.updateAboutData({
          'summary': _summaryController.text.trim(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        if (!mounted) return;
        _showSuccessSnackBar('About section updated successfully');
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar('Error updating about section: $e');
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Write a compelling summary about your professional background, skills, and experience.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _summaryController,
            maxLines: 8,
            style: GoogleFonts.inter(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter your professional summary...',
              hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
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
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your professional summary';
              }
              if (value.trim().length < 50) {
                return 'Summary should be at least 50 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.glassBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppTheme.neonCyan,
                ),
                const SizedBox(width: 8),
                Text(
                  'Character count: ${_summaryController.text.length}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveAbout,
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
                      'Save About Section',
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
