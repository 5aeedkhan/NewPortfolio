import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/services/portfolio_service.dart';

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
      if (!mounted) {
        return;
      }
      if (data != null) {
        setState(() {
          _summaryController.text = data['summary'] ?? '';
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showErrorSnackBar('Error loading about data');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

        if (!mounted) {
          return;
        }
        _showSuccessSnackBar('About section updated successfully');
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) {
          return;
        }
        _showErrorSnackBar('Error updating about section: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
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
          Text(
            'Professional Summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(),
          
          const SizedBox(height: 8),
          
          Text(
            'Write a compelling summary about your professional background, skills, and experience.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 100)),
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _summaryController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Enter your professional summary...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
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
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 200)),

          const SizedBox(height: 16),

          // Character count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Character count: ${_summaryController.text.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 300)),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveAbout,
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
                      'Save About Section',
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
