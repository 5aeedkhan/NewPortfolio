import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';

class SocialLink {
  String platform;
  String url;
  IconData icon;
  Color color;

  SocialLink({
    required this.platform,
    required this.url,
    required this.icon,
    required this.color,
  });
}

class EditSocialLinksForm extends StatefulWidget {
  const EditSocialLinksForm({super.key});

  @override
  State<EditSocialLinksForm> createState() => _EditSocialLinksFormState();
}

class _EditSocialLinksFormState extends State<EditSocialLinksForm> {
  final PortfolioService _portfolioService = PortfolioService();
  bool _isLoading = false;

  final List<SocialLink> _socialLinks = [
    SocialLink(platform: 'GitHub', url: '', icon: Icons.code, color: AppTheme.neonCyan),
    SocialLink(platform: 'LinkedIn', url: '', icon: Icons.work, color: AppTheme.neonBlue),
    SocialLink(platform: 'Twitter', url: '', icon: Icons.alternate_email, color: AppTheme.neonCyan),
    SocialLink(platform: 'Facebook', url: '', icon: Icons.facebook, color: AppTheme.neonBlue),
    SocialLink(platform: 'Instagram', url: '', icon: Icons.camera_alt, color: AppTheme.neonPink),
    SocialLink(platform: 'Email', url: '', icon: Icons.email, color: AppTheme.neonPink),
    SocialLink(platform: 'Website', url: '', icon: Icons.language, color: AppTheme.neonGreen),
  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSocialLinksData();
  }

  void _initializeControllers() {
    for (var link in _socialLinks) {
      _controllers[link.platform] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSocialLinksData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _portfolioService.getSocialLinksData();
      if (!mounted) return;
      if (data != null && data['links'] != null) {
        final List<dynamic> links = data['links'];
        for (var linkData in links) {
          final platform = linkData['platform'] as String;
          final url = linkData['url'] as String;
          final index = _socialLinks.indexWhere((link) => link.platform == platform);
          if (index != -1) {
            _socialLinks[index].url = url;
            _controllers[platform]?.text = url;
          }
        }
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error loading social links data');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSocialLinks() async {
    setState(() => _isLoading = true);
    try {
      final linksData = _socialLinks
          .map((link) => {
                'platform': link.platform,
                'url': link.url.trim(),
                'icon': link.icon.codePoint.toString(),
                'color': link.color.toARGB32().toString(),
              })
          .where((link) => link['url'].toString().isNotEmpty)
          .toList();

      await _portfolioService.updateSocialLinksData({
        'links': linksData,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      if (!mounted) return;
      _showSuccessSnackBar('Social links updated successfully');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error updating social links: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: AppTheme.textPrimary)),
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
        content: Text(message, style: GoogleFonts.inter(color: AppTheme.textPrimary)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Social Links',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add or update your social media and contact links. Empty fields will be hidden.',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _socialLinks.length,
            itemBuilder: (context, index) {
              final link = _socialLinks[index];
              final controller = _controllers[link.platform]!;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: link.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: link.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(link.icon, color: link.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          link.platform,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller,
                      style: GoogleFonts.inter(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter ${link.platform.toLowerCase()} URL',
                        hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
                        prefixIcon: Icon(Icons.link, color: link.color),
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
                        fillColor: AppTheme.bgElevated,
                      ),
                      onChanged: (value) {
                        link.url = value;
                      },
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (!value.startsWith('http://') &&
                              !value.startsWith('https://') &&
                              link.platform != 'Email') {
                            return 'Please enter a valid URL starting with http:// or https://';
                          }
                          if (link.platform == 'Email' && !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveSocialLinks,
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
                    'Save Social Links',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }
}
