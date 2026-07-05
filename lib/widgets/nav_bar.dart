import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/screens/admin_panel.dart';
import 'package:portfolio/screens/login_screen.dart';
import 'dart:ui';

class NavBar extends StatelessWidget {
  final ScrollController scrollController;
  final GlobalKey heroKey;
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey projectsKey;
  final GlobalKey contactKey;
  final int activeIndex;
  final double scrollProgress;
  final VoidCallback? onAdminPanelClosed;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.heroKey,
    required this.aboutKey,
    required this.skillsKey,
    required this.projectsKey,
    required this.contactKey,
    required this.activeIndex,
    this.scrollProgress = 0,
    this.onAdminPanelClosed,
  });

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final sections = [
      {'label': 'Home', 'index': 0, 'key': heroKey},
      {'label': 'About', 'index': 1, 'key': aboutKey},
      {'label': 'Skills', 'index': 2, 'key': skillsKey},
      {'label': 'Projects', 'index': 3, 'key': projectsKey},
      {'label': 'Contact', 'index': 4, 'key': contactKey},
    ];

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.glassBorder,
                        width: 1,
                      ),
                      boxShadow: AppTheme.neonGlow(
                        color: AppTheme.neonCyan,
                        blurRadius: 15,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: isMobile
                        ? _buildMobileNav(context, sections)
                        : _buildDesktopNav(context, sections),
                  ),
                ),
              ),
            ),
            // Scroll progress bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 2,
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: scrollProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.neonLinearGradient(),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNav(
      BuildContext context, List<Map<String, dynamic>> sections) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo / Name
        GestureDetector(
          onTap: () => _scrollToKey(heroKey),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppTheme.neonLinearGradient(),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: AppTheme.neonGlow(
                      color: AppTheme.neonCyan,
                      blurRadius: 10,
                    ),
                  ),
                  child: const Icon(
                    Icons.code,
                    color: AppTheme.bgDarkest,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.textGradient.createShader(bounds),
                  child: Text(
                    'Muhammad Saeed Khan',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Nav links
        Row(
          children: sections.map((section) {
            final isActive = activeIndex == section['index'] as int;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => _scrollToKey(section['key'] as GlobalKey),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.neonCyan.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? AppTheme.neonCyan.withValues(alpha: 0.4)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      section['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? AppTheme.neonCyan
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        // Auth buttons
        _buildAuthButtons(context),
      ],
    );
  }

  Widget _buildMobileNav(
      BuildContext context, List<Map<String, dynamic>> sections) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: AppTheme.neonLinearGradient(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.code,
                color: AppTheme.bgDarkest,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.textGradient.createShader(bounds),
              child: Text(
                'M. Saeed Khan',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        // Condensed nav icons
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sections.map((section) {
                final isActive = activeIndex == section['index'] as int;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () => _scrollToKey(section['key'] as GlobalKey),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.neonCyan.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        section['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive
                              ? AppTheme.neonCyan
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Auth icon
        _buildAuthButtons(context, isMobile: true),
      ],
    );
  }

  Widget _buildAuthButtons(BuildContext context, {bool isMobile = false}) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavIconButton(
                context,
                Icons.admin_panel_settings,
                'Admin',
                () => Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const AdminPanel(),
                    ),
                  )
                  .then((_) => onAdminPanelClosed?.call()),
                AppTheme.neonPurple,
                isMobile,
              ),
              if (!isMobile) const SizedBox(width: 6),
              _buildNavIconButton(
                context,
                Icons.logout,
                'Logout',
                () => FirebaseAuth.instance.signOut(),
                AppTheme.neonPink,
                isMobile,
              ),
            ],
          );
        } else {
          return _buildNavIconButton(
            context,
            Icons.login,
            'Login',
            () => showDialog(
              context: context,
              builder: (context) => const LoginScreen(),
            ),
            AppTheme.neonCyan,
            isMobile,
          );
        }
      },
    );
  }

  Widget _buildNavIconButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
    Color color,
    bool isMobile,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: isMobile ? 16 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
