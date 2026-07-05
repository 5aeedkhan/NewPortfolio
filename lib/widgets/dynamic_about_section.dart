import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/scroll_reveal.dart';

class DynamicAboutSection extends StatefulWidget {
  const DynamicAboutSection({super.key});

  @override
  State<DynamicAboutSection> createState() => _DynamicAboutSectionState();
}

class _DynamicAboutSectionState extends State<DynamicAboutSection> {
  final PortfolioService _portfolioService = PortfolioService();
  String _summary = '';
  String _cvUrl = '';
  String _cvTitle = 'View Full CV';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAboutData();
  }

  Future<void> _loadAboutData() async {
    try {
      // Load about data
      final aboutData = await _portfolioService.getAboutData();
      if (aboutData != null) {
        setState(() {
          _summary = aboutData['summary'] ?? '';
        });
      } else {
        // Use default summary
        setState(() {
          _summary =
              'I am a passionate and detail-oriented Computer Science graduate with hands-on experience building cross-platform mobile apps using Flutter and Dart. I have worked through the full app development cycle — from gathering requirements and designing clean, user-friendly interfaces to integrating APIs and deploying functional, high-performing apps. I am well-versed in using Firebase, REST APIs, and various third-party tools to create solid mobile solutions. Currently, I am working as a Flutter Developer at IT Artificer, while also teaching as a Lecturer at KPIMS. This mix of development and teaching lets me apply my technical skills while helping others grow, which I genuinely enjoy.';
        });
      }

      // Load CV data
      final cvData = await _portfolioService.getCVData();
      if (cvData != null) {
        setState(() {
          _cvUrl = cvData['cvUrl'] ?? '';
          _cvTitle = cvData['cvTitle'] ?? 'View Full CV';
        });
      } else {
        // Use default CV URL
        setState(() {
          _cvUrl =
              'https://drive.google.com/file/d/19CYzti5pEICeUtLLjVyIawMiZra8Q3vT/view?usp=sharing';
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading about data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    if (_isLoading) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : isTablet ? 32 : 48,
          vertical: 60,
        ),
        color: AppTheme.bgDark,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.neonCyan.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : isTablet ? 32 : 48,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.bgDark,
            AppTheme.bgDarkest,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading with gradient text
          ScrollReveal(child: _buildSectionHeading(isMobile)),

          SizedBox(height: isMobile ? 32 : 48),

          // Professional Summary Card
          ScrollReveal(
            delay: 150.ms,
            child: _buildSummaryCard(isMobile, isTablet),
          ),

          SizedBox(height: 32),

          // View Full CV Button
          ScrollReveal(
            delay: 300.ms,
            child: Center(child: _buildCvButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.textGradient.createShader(bounds),
          child: Text(
            'About Me',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: AppTheme.neonLinearGradient(),
            borderRadius: BorderRadius.circular(2),
          ),
        ).animate().fadeIn(delay: 200.ms).scaleX(begin: 0),
      ],
    );
  }

  Widget _buildSummaryCard(bool isMobile, bool isTablet) {
    final maxWidth = isMobile ? double.infinity : (isTablet ? 700.0 : 800.0);

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
                  color: AppTheme.neonPurple,
                  blurRadius: 20,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.neonCyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.neonCyan.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: AppTheme.neonCyan,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Professional Summary',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideX(delay: 100.ms),
                  const SizedBox(height: 20),
                  Text(
                    _summary,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 14 : 16,
                      height: 1.7,
                      color: AppTheme.textSecondary,
                    ),
                  ).animate().fadeIn().slideY(delay: 150.ms, begin: 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildCvButton() {
    return _CvButton(cvUrl: _cvUrl, cvTitle: _cvTitle)
        .animate()
        .fadeIn()
        .slideY(delay: 300.ms, begin: 0.2);
  }
}

class _CvButton extends StatefulWidget {
  final String cvUrl;
  final String cvTitle;

  const _CvButton({required this.cvUrl, required this.cvTitle});

  @override
  State<_CvButton> createState() => _CvButtonState();
}

class _CvButtonState extends State<_CvButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () async {
          if (widget.cvUrl.isNotEmpty) {
            final uri = Uri.parse(widget.cvUrl);
            final canLaunch = await canLaunchUrl(uri);
            if (!context.mounted) return;
            if (canLaunch) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Could not open CV link: ${widget.cvUrl}'),
                ),
              );
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.neonLinearGradient(),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovered
                ? AppTheme.neonGlow(
                    color: AppTheme.neonCyan, blurRadius: 20)
                : AppTheme.neonGlow(
                    color: AppTheme.neonCyan, blurRadius: 10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.description,
                color: AppTheme.bgDarkest,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                widget.cvTitle,
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
    );
  }
}
