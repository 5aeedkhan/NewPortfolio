import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/scroll_reveal.dart';

class ExperienceItem {
  final String role;
  final String company;
  final String period;
  final String description;
  final List<String> achievements;
  final IconData icon;
  final Color color;

  const ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
    required this.achievements,
    required this.icon,
    required this.color,
  });
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const List<ExperienceItem> _experiences = [
    ExperienceItem(
      role: 'Flutter Developer',
      company: 'Freelance',
      period: '2023 — Present',
      description:
          'Building cross-platform mobile and web applications with Flutter, delivering high-quality UI and seamless user experiences.',
      achievements: [
        'Developed 15+ production-ready Flutter apps',
        'Integrated Firebase, REST APIs, and third-party services',
        'Implemented responsive designs for mobile, tablet, and web',
      ],
      icon: Icons.code,
      color: AppTheme.neonCyan,
    ),
    ExperienceItem(
      role: 'Mobile App Developer',
      company: 'Various Startups',
      period: '2022 — 2023',
      description:
          'Worked with startups to build MVPs and scale their mobile applications from idea to launch.',
      achievements: [
        'Published apps on Play Store and App Store',
        'Optimized app performance and reduced load times by 40%',
        'Collaborated with designers and backend teams',
      ],
      icon: Icons.phone_android,
      color: AppTheme.neonPurple,
    ),
    ExperienceItem(
      role: 'Computer Science Student',
      company: 'University',
      period: '2020 — 2024',
      description:
          'Pursued a degree in Computer Science, focusing on software engineering, algorithms, and mobile development.',
      achievements: [
        'Built foundational knowledge in data structures and algorithms',
        'Completed multiple projects using Flutter and Dart',
        'Participated in coding competitions and hackathons',
      ],
      icon: Icons.school,
      color: AppTheme.neonBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isMobile ? 16 : 48,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
          ScrollReveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.textGradient.createShader(bounds),
                  child: Text(
                    'Experience',
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 26 : 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: AppTheme.neonLinearGradient(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'My professional journey so far',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 13 : 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isMobile ? 32 : 48),

          // Timeline
          _buildTimeline(isMobile),
        ],
      ),
    );
  }

  Widget _buildTimeline(bool isMobile) {
    return Column(
      children: _experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final exp = entry.value;
        final isLast = index == _experiences.length - 1;

        return ScrollReveal(
          delay: Duration(milliseconds: index * 150),
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline line + dot
                Column(
                  children: [
                    // Icon dot
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.bgCard,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: exp.color.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: exp.color.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        exp.icon,
                        color: exp.color,
                        size: 22,
                      ),
                    ),
                    // Connecting line
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              exp.color.withValues(alpha: 0.4),
                              AppTheme.glassBorder,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 20),

                // Content card
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                        decoration: BoxDecoration(
                          color: AppTheme.glassBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: exp.color.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Period badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: exp.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: exp.color.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                exp.period,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: exp.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Role
                            Text(
                              exp.role,
                              style: GoogleFonts.poppins(
                                fontSize: isMobile ? 16 : 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Company
                            Text(
                              exp.company,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 13 : 15,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Description
                            Text(
                              exp.description,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 13 : 14,
                                color: AppTheme.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Achievements
                            ...exp.achievements.map((achievement) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: exp.color,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        achievement,
                                        style: GoogleFonts.inter(
                                          fontSize: isMobile ? 12 : 13,
                                          color: AppTheme.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
