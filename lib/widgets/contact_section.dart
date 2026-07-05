import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/services/portfolio_service.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final PortfolioService _portfolioService = PortfolioService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        await _portfolioService.submitContactMessage(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          message: _messageController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.neonCyan),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Message sent! I\'ll get back to you soon.',
                      style: GoogleFonts.inter(color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.bgCardLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppTheme.neonCyan.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: AppTheme.neonPink),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Failed to send message. Please try again.',
                      style: GoogleFonts.inter(color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.bgCardLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppTheme.neonPink.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isMobile ? 16 : isTablet ? 32 : 48,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.bgDarkest,
            AppTheme.bgDark,
          ],
        ),
      ),
      child: Column(
        children: [
          // Section heading
          _buildSectionHeading(isMobile),

          SizedBox(height: isMobile ? 32 : 48),

          // Contact form card
          _buildContactForm(isMobile, isTablet),

          SizedBox(height: isMobile ? 24 : 32),

          // Quick contact info
          _buildQuickInfo(isMobile),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(bool isMobile) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.textGradient.createShader(bounds),
          child: Text(
            'Get In Touch',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ).animate().fadeIn().slideY(begin: 0.3),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: AppTheme.neonLinearGradient(),
            borderRadius: BorderRadius.circular(2),
          ),
        ).animate().fadeIn(delay: 200.ms).scaleX(begin: 0),
        const SizedBox(height: 16),
        Text(
          'Have a project in mind or just want to say hi? Drop me a message!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 14 : 16,
            color: AppTheme.textSecondary,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildContactForm(bool isMobile, bool isTablet) {
    final maxWidth = isMobile ? double.infinity : (isTablet ? 600.0 : 700.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                color: AppTheme.glassBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.glassBorder,
                  width: 1,
                ),
                boxShadow: AppTheme.neonGlow(
                  color: AppTheme.neonCyan,
                  blurRadius: 20,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Your Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Your Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Message field
                    _buildTextField(
                      controller: _messageController,
                      label: 'Your Message',
                      icon: Icons.message_outlined,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a message';
                        }
                        if (value.trim().length < 10) {
                          return 'Message should be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: _buildSubmitButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(
        color: AppTheme.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.neonCyan, size: 20),
        filled: true,
        fillColor: AppTheme.bgCard,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.neonPink.withValues(alpha: 0.5)),
        ),
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isSubmitting ? null : _submitMessage,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.neonLinearGradient(),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isSubmitting
                ? []
                : AppTheme.neonGlow(
                    color: AppTheme.neonCyan,
                    blurRadius: 15,
                  ),
          ),
          child: Center(
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.bgDarkest),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.send,
                        color: AppTheme.bgDarkest,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Send Message',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.bgDarkest,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo(bool isMobile) {
    final items = [
      {'icon': Icons.email, 'label': 'Email', 'value': 'ms4eedkhan@gmail.com'},
      {'icon': Icons.phone, 'label': 'WhatsApp', 'value': '+92 335 9350658'},
      {'icon': Icons.location_on, 'label': 'Location', 'value': 'Pakistan'},
    ];

    return Wrap(
      spacing: isMobile ? 12 : 24,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.glassBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item['icon'] as IconData,
                color: AppTheme.neonCyan,
                size: 18,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  Text(
                    item['value'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }
}
