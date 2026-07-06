import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/dynamic_social_links.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final year = DateTime.now().year;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isMobile ? 20 : 80,
      ),
      decoration: BoxDecoration(
        color: AppTheme.bgDarkest,
        border: Border(
          top: BorderSide(
            color: AppTheme.neonCyan.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Neon divider line
          Container(
            width: 120,
            height: 2,
            decoration: BoxDecoration(
              gradient: AppTheme.neonLinearGradient(),
              borderRadius: BorderRadius.circular(1),
            ),
          ).animate().fadeIn().scaleX(begin: 0),

          const SizedBox(height: 24),

          // Social links
          const DynamicSocialLinks(),

          const SizedBox(height: 24),

          // Name / brand
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.textGradient.createShader(bounds),
            child: Text(
              'Saeed Khan',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Copyright
          Text(
            '© $year Saeed Khan. All rights reserved.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),

          const SizedBox(height: 8),

          // Built with
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Built with ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              Icon(
                Icons.favorite,
                size: 12,
                color: AppTheme.neonPink.withValues(alpha: 0.7),
              ),
              Text(
                ' using Flutter',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}
