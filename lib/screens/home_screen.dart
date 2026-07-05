import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/nav_bar.dart';
import 'package:portfolio/widgets/dynamic_about_section.dart';
import 'package:portfolio/widgets/dynamic_skills_section.dart';
import 'package:portfolio/widgets/projects_section.dart';
import 'package:portfolio/widgets/contact_section.dart';
import 'package:portfolio/widgets/footer.dart';
import 'package:portfolio/widgets/dynamic_social_links.dart';
import 'package:portfolio/widgets/experience_section.dart';
import 'package:portfolio/widgets/scroll_reveal.dart';
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
  double _scrollProgress = 0;

  String _name = 'Muhammad Saeed Khan';
  String _profileImageUrl = '';
  bool _isLoadingProfile = true;
  List<Map<String, dynamic>> _heroStats = [];

  static const List<Map<String, dynamic>> _defaultHeroStats = [
    {'value': 3, 'suffix': '+', 'label': 'Years Experience'},
    {'value': 20, 'suffix': '+', 'label': 'Projects Done'},
    {'value': 15, 'suffix': '+', 'label': 'Happy Clients'},
    {'value': 5, 'suffix': '', 'label': 'Tech Stacks'},
  ];

  late AnimationController _gradientController;
  late AnimationController _orbController;
  late AnimationController _typewriterController;

  // Typewriter
  final List<String> _titles = [
    'Flutter Developer',
    'UI/UX Enthusiast',
    'Mobile App Engineer',
    'Problem Solver',
  ];
  int _currentTitleIndex = 0;
  String _displayedTitle = '';
  int _charIndex = 0;
  bool _isDeleting = false;

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
    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addStatusListener(_onTypewriterTick);

    _scrollController.addListener(_onScroll);
    _loadProfileData();
    _startTypewriter();
  }

  void _startTypewriter() {
    _charIndex = 0;
    _displayedTitle = '';
    _isDeleting = false;
    _typewriterController.duration =
        const Duration(milliseconds: 80);
    _typewriterController.reset();
    _typewriterController.forward();
  }

  void _onTypewriterTick(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final fullText = _titles[_currentTitleIndex];

      if (!_isDeleting) {
        if (_charIndex < fullText.length) {
          _charIndex++;
          _displayedTitle = fullText.substring(0, _charIndex);
          _typewriterController.reset();
          _typewriterController.forward();
        } else {
          Future.delayed(const Duration(milliseconds: 1800), () {
            if (mounted) {
              _isDeleting = true;
              _typewriterController.duration =
                  const Duration(milliseconds: 45);
              _typewriterController.reset();
              _typewriterController.forward();
            }
          });
        }
      } else {
        if (_charIndex > 0) {
          _charIndex--;
          _displayedTitle = fullText.substring(0, _charIndex);
          _typewriterController.reset();
          _typewriterController.forward();
        } else {
          _isDeleting = false;
          _currentTitleIndex =
              (_currentTitleIndex + 1) % _titles.length;
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _typewriterController.duration =
                  const Duration(milliseconds: 80);
              _typewriterController.reset();
              _typewriterController.forward();
            }
          });
        }
      }

      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _orbController.dispose();
    _typewriterController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
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

    final shouldShow = _scrollController.offset > 400;
    if (_showScrollToTop != shouldShow) {
      setState(() => _showScrollToTop = shouldShow);
    }

    // Scroll progress for nav bar
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll > 0) {
      final progress = (_scrollController.offset / maxScroll).clamp(0.0, 1.0);
      if ((progress - _scrollProgress).abs() > 0.01) {
        setState(() => _scrollProgress = progress);
      }
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
    setState(() => _isLoadingProfile = true);
    try {
      final data = await _portfolioService.getProfileData();
      debugPrint('Profile data loaded: $data');
      if (data != null) {
        var imageUrl = data['profileImageUrl'] ?? '';
        if (imageUrl.isNotEmpty && imageUrl.startsWith('http://')) {
          imageUrl = imageUrl.replaceFirst('http://', 'https://');
        }
        debugPrint('Profile image URL: $imageUrl');
        setState(() {
          _name = data['name'] ?? 'Muhammad Saeed Khan';
          _profileImageUrl = imageUrl;
          _isLoadingProfile = false;
        });
      } else {
        debugPrint('No profile data found in Firestore');
        setState(() => _isLoadingProfile = false);
      }

      // Load hero stats
      final stats = await _portfolioService.getHeroStats();
      if (stats.isNotEmpty) {
        setState(() => _heroStats = stats);
      } else {
        setState(() => _heroStats = List.from(_defaultHeroStats));
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      setState(() {
        _isLoadingProfile = false;
        _heroStats = List.from(_defaultHeroStats);
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
                _buildHeroSection(isMobile, screenHeight),
                Container(
                  key: _aboutKey,
                  child: DynamicAboutSection(
                    scrollController: _scrollController,
                  ),
                ),
                Container(
                  key: _skillsKey,
                  child: DynamicSkillsSection(
                    scrollController: _scrollController,
                  ),
                ),
                ExperienceSection(
                  scrollController: _scrollController,
                ),
                Container(
                  key: _projectsKey,
                  child: const ProjectsSection(),
                ),
                Container(
                  key: _contactKey,
                  child: const ContactSection(),
                ),
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
            scrollProgress: _scrollProgress,
            onAdminPanelClosed: _loadProfileData,
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

  // ── Hero Section ──

  Widget _buildHeroSection(bool isMobile, double screenHeight) {
    return Container(
      key: _heroKey,
      height: screenHeight,
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final value = _gradientController.value;
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

              // Radial glow at center-top
              Positioned(
                top: -100,
                left: 0,
                right: 0,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [
                        AppTheme.neonCyan.withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Floating neon orbs with parallax
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
      // Large cyan orb - top right
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          final scrollOffset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          return Positioned(
            top: 80 + 30 * t - scrollOffset * 0.3,
            right: isMobile ? 20 : 80,
            child: Container(
              width: isMobile ? 120 : 220,
              height: isMobile ? 120 : 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonCyan.withValues(alpha: 0.18),
                    AppTheme.neonCyan.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Purple orb - bottom left
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          final scrollOffset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          return Positioned(
            bottom: 100 + 40 * (1 - t) + scrollOffset * 0.2,
            left: isMobile ? 10 : 60,
            child: Container(
              width: isMobile ? 100 : 200,
              height: isMobile ? 100 : 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonPurple.withValues(alpha: 0.15),
                    AppTheme.neonPurple.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Small blue orb - mid left
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          final scrollOffset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          return Positioned(
            top: 200 + 20 * t - scrollOffset * 0.5,
            left: isMobile ? 40 : 200,
            child: Container(
              width: isMobile ? 60 : 120,
              height: isMobile ? 60 : 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonBlue.withValues(alpha: 0.12),
                    AppTheme.neonBlue.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Pink orb - far right mid
      AnimatedBuilder(
        animation: _orbController,
        builder: (context, child) {
          final t = _orbController.value;
          final scrollOffset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          return Positioned(
            top: 350 + 25 * (1 - t) - scrollOffset * 0.4,
            right: isMobile ? 30 : 150,
            child: Container(
              width: isMobile ? 50 : 90,
              height: isMobile ? 50 : 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.neonPink.withValues(alpha: 0.1),
                    AppTheme.neonPink.withValues(alpha: 0.03),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        children: [
          // Profile image with neon ring
          _buildProfileImage(imageSize, isMobile),

          SizedBox(height: isMobile ? 20 : 28),

          // Greeting
          Text(
            'Hello, I\'m',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 20,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

          SizedBox(height: isMobile ? 6 : 10),

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

          // Typewriter title
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _displayedTitle,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 15 : 20,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neonCyan,
                  ),
                ),
                // Blinking cursor
                AnimatedBuilder(
                  animation: _gradientController,
                  builder: (context, child) {
                    final visible =
                        (_gradientController.value * 2).floor() % 2 == 0;
                    return Container(
                      width: 2,
                      height: isMobile ? 18 : 24,
                      margin: const EdgeInsets.only(left: 4),
                      color: visible
                          ? AppTheme.neonCyan
                          : Colors.transparent,
                    );
                  },
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.3),

          SizedBox(height: isMobile ? 24 : 32),

          // Animated stats row
          _buildStatsRow(isMobile),

          SizedBox(height: isMobile ? 20 : 28),

          // Social links
          const DynamicSocialLinks()
              .animate()
              .fadeIn(duration: 600.ms, delay: 800.ms)
              .slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    final stats = _heroStats.isNotEmpty ? _heroStats : _defaultHeroStats;

    return Wrap(
      spacing: isMobile ? 12 : 24,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: stats.map((stat) {
        return Column(
          children: [
            AnimatedCounter(
              target: (stat['value'] as num).toInt(),
              suffix: stat['suffix'] as String? ?? '',
              scrollController: _scrollController,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.neonCyan,
              ),
            ),
            Text(
              stat['label'] as String,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 10 : 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        );
      }).toList(),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms)
        .slideY(begin: 0.3);
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
                  color:
                      AppTheme.neonPurple.withValues(alpha: glowOpacity * 0.7),
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
                  child: SizedBox(
                    width: size - 8,
                    height: size - 8,
                    child: _isLoadingProfile
                        ? ShimmerProfilePlaceholder(size: size - 8)
                        : (_profileImageUrl.isNotEmpty
                            ? Image.network(
                                _profileImageUrl,
                                fit: BoxFit.cover,
                                width: size - 8,
                                height: size - 8,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return ShimmerProfilePlaceholder(size: size - 8);
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint('Profile image load error: $error');
                                  debugPrint('Image URL: $_profileImageUrl');
                                  return _buildDefaultAvatar(size - 8);
                                },
                              )
                            : _buildDefaultAvatar(size - 8)),
                  ),
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
