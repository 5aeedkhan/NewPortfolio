import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/nav_bar.dart';
import 'package:portfolio/widgets/dynamic_about_section.dart';
import 'package:portfolio/widgets/dynamic_skills_section.dart';
import 'package:portfolio/widgets/projects_section.dart';
import 'package:portfolio/widgets/contact_section.dart';
import 'package:portfolio/widgets/footer.dart';
import 'package:portfolio/widgets/dynamic_social_links.dart';
import 'package:portfolio/services/portfolio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PortfolioService _portfolioService = PortfolioService();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _activeSection = 0;
  bool _showScrollToTop = false;

  // Hero data
  String _name = 'Saeed Khan';
  String _title = 'Flutter Developer';
  String _profileImageUrl = '';
  bool _isLoadingProfile = true;

  // Animated gradient
  late AnimationController _gradientController;
  late AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _scrollController.addListener(_onScroll);
    _loadProfileData();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _orbController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Determine active section
    final sections = [
      _heroKey,
      _aboutKey,
      _skillsKey,
      _projectsKey,
      _contactKey,
    ];

    for (int i = 0; i < sections.length; i++) {
      final ctx = sections[i].currentContext;
      if (ctx != null) {
        final renderBox = ctx.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final offset = renderBox.localToGlobal(Offset.zero);
          if (offset.dy > 0 && offset.dy < 200) {
            if (_activeSection != i) {
              setState(() => _activeSection = i);
            }
            break;
          }
        }
      }
    }

    // Show/hide scroll-to-top
    final shouldShow = _scrollController.offset > 400;
    if (_showScrollToTop != shouldShow) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _loadProfileData() async {
    try {
      final data = await _portfolioService.getProfileData();
      if (data != null) {
        setState(() {
          _name = data['name'] ?? 'Saeed Khan';
          _title = data['title'] ?? 'Flutter Developer';
          _profileImageUrl = data['profileImageUrl'] ?? '';
          _isLoadingProfile = false;
        });
      } else {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.bgDarkest,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero Section
                _buildHeroSection(isMobile, screenHeight),

                // About Section
                Container(
                  key: _aboutKey,
                  child: const DynamicAboutSection(),
                ),

                // Skills Section
                Container(
                  key: _skillsKey,
                  child: const DynamicSkillsSection(),
                ),

                // Projects Section
                Container(
                  key: _projectsKey,
                  child: const ProjectsSection(),
                ),

                // Contact Section
                Container(
                  key: _contactKey,
                  child: const ContactSection(),
                ),

                // Footer
                const Footer(),
              ],
            ),
          ),

          // Navigation Bar
          NavBar(
            scrollController: _scrollController,
            heroKey: _heroKey,
            aboutKey: _aboutKey,
            skillsKey: _skillsKey,
            projectsKey: _projectsKey,
            contactKey: _contactKey,
            activeIndex: _activeSection,
          ),

          // Scroll-to-top button
          if (_showScrollToTop)
            Positioned(
              bottom: 24,
              right: 24,
              child: _buildScrollToTopButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile, double screenHeight) {
    return Container(
      key: _heroKey,
      height: screenHeight,
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final value = _gradientController.value;
          // Shifting gradient colors
          final t = (math.sin(value * 2 * math.pi) + 1) / 2;

          return Stack(
            children: [
              // Animated gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        AppTheme.bgDarkest,
                        const Color(0xFF0A1628),
                        t,
                      )!,
                      Color.lerp(
                        AppTheme.bgDark,
                        const Color(0xFF0D1525),
                        1 - t,
                      )!,
                      Color.lerp(
                        AppTheme.bgCard,
                        const Color(0xFF101828),
                        t,
                      )!,
                    ],
                  ),
                ),
              ),

              // Floating neon orbs
              ..._buildFloatingOrbs(isMobile),

              // Grid pattern overlay
              CustomPaint(
                size: Size.infinite,
                painter: GridPatternPainter(),
              ),

              // Content
              SafeArea(
                child: Center(
                  child: _buildHeroContent(isMobile),
                ),
              ),

              // Scroll-down indicator
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: _buildScrollIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildFloatingOrbs(bool isMobile) {
    return [
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          return Positioned(
            top: 80 + 30 * t,
            right: isMobile ? 20 : 80,
            child: Container(
              width: isMobile ? 120 : 200,
              height: isMobile ? 120 : 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonCyan.withValues(alpha: 0.15),
                    AppTheme.neonCyan.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          return Positioned(
            bottom: 100 + 40 * (1 - t),
            left: isMobile ? 10 : 60,
            child: Container(
              width: isMobile ? 100 : 180,
              height: isMobile ? 100 : 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonPurple.withValues(alpha: 0.12),
                    AppTheme.neonPurple.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          return Positioned(
            top: 200 + 20 * t,
            left: isMobile ? 40 : 200,
            child: Container(
              width: isMobile ? 60 : 100,
              height: isMobile ? 60 : 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonBlue.withValues(alpha: 0.1),
                    AppTheme.neonBlue.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  Widget _buildHeroContent(bool isMobile) {
    final imageSize = isMobile ? 120.0 : 180.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile image with neon ring
          _buildProfileImage(imageSize, isMobile),

          SizedBox(height: isMobile ? 24 : 32),

          // Greeting
          Text(
            'Hello, I\'m',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 20,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

          SizedBox(height: isMobile ? 8 : 12),

          // Name with gradient text
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: AppTheme.neonGradientFull,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              _name,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 36 : 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.3),

          SizedBox(height: isMobile ? 8 : 12),

          // Title with typewriter-like effect
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.glassBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.neonCyan.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _title,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 16 : 22,
                fontWeight: FontWeight.w500,
                color: AppTheme.neonCyan,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.3),

          SizedBox(height: isMobile ? 20 : 28),

          // Social links
          const DynamicSocialLinks()
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildProfileImage(double size, bool isMobile) {
    return AnimatedBuilder(
      animation: _orbController,
      builder: (context, child) {
        final t = _orbController.value;
        final pulseScale = 1.0 + 0.03 * t;
        final glowOpacity = 0.3 + 0.15 * t;

        return Transform.scale(
          scale: pulseScale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: AppTheme.neonGradientFull,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonCyan.withValues(alpha: glowOpacity),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: AppTheme.neonPurple.withValues(alpha: glowOpacity * 0.7),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bgCard,
                  border: Border.all(
                    color: AppTheme.bgDarkest,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _isLoadingProfile
                      ? ShimmerProfilePlaceholder(size: size - 8)
                      : (_profileImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: _profileImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  ShimmerProfilePlaceholder(size: size - 8),
                              errorWidget: (context, url, error) =>
                                  _buildDefaultAvatar(size - 8),
                            )
                          : _buildDefaultAvatar(size - 8)),
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      color: AppTheme.bgElevated,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        Text(
          'Scroll Down',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _orbController,
          builder: (context, child) {
            final t = _orbController.value;
            return Transform.translate(
              offset: Offset(0, 8 * t),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.neonCyan.withValues(alpha: 0.6 + 0.3 * t),
                size: 28,
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms);
  }

  Widget _buildScrollToTopButton() {
    return GestureDetector(
      onTap: _scrollToTop,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.neonLinearGradient(),
            shape: BoxShape.circle,
            boxShadow: AppTheme.neonGlow(
              color: AppTheme.neonCyan,
              blurRadius: 15,
            ),
          ),
          child: const Icon(
            Icons.keyboard_arrow_up,
            color: AppTheme.bgDarkest,
            size: 24,
          ),
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.5, 0.5));
  }
}

/// Shimmer placeholder for profile image while loading.
class ShimmerProfilePlaceholder extends StatelessWidget {
  final double size;
  const ShimmerProfilePlaceholder({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: AppTheme.bgElevated,
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
}

/// Subtle grid pattern painter for hero background.
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.neonCyan.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
