import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/widgets/social_links.dart';
import 'package:portfolio/widgets/about_section.dart';
import 'package:portfolio/widgets/projects_section.dart';
import 'package:portfolio/widgets/skills_section.dart';
import 'package:portfolio/widgets/dynamic_social_links.dart';
import 'package:portfolio/widgets/dynamic_about_section.dart';
import 'package:portfolio/widgets/dynamic_skills_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/screens/admin_panel.dart';
import 'package:portfolio/screens/login_screen.dart';
import 'package:portfolio/services/portfolio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PortfolioService _portfolioService = PortfolioService();
  
  // Profile data
  String _profileName = 'Muhammad Saeed Khan';
  String _profileTitle = 'Mobile App Developer';
  String _profileImageUrl = 'https://i.ibb.co/P7rHjyV/Whats-App-Image-2025-05-16-at-9-39-19-AM.jpg';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final data = await _portfolioService.getProfileData();
      if (data != null) {
        setState(() {
          _profileName = data['name'] ?? _profileName;
          _profileTitle = data['title'] ?? _profileTitle;
          _profileImageUrl = data['profileImageUrl'] ?? _profileImageUrl;
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Widget _buildAppBarButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        tooltip: tooltip,
        padding: const EdgeInsets.all(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'My Portfolio',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      _buildAppBarButton(
                        context,
                        Icons.admin_panel_settings,
                        'Admin Panel',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AdminPanel(),
                            ),
                          );
                        },
                        Colors.purple,
                      ),
                      const SizedBox(width: 8),
                      _buildAppBarButton(
                        context,
                        Icons.logout,
                        'Logout',
                        () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        Colors.red,
                      ),
                    ],
                  );
                } else {
                  return _buildAppBarButton(
                    context,
                    Icons.login,
                    'Login',
                    () {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginScreen(),
                      );
                    },
                    Theme.of(context).primaryColor,
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image with optimized loading
                    Hero(
                      tag: 'profile_image',
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _profileImageUrl,
                            width: 190,
                            height: 220,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn().scale(),

                    const SizedBox(height: 20),

                    // Name with optimized text rendering
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        _profileName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width < 600 ? 32 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.3),
                    ),

                    const SizedBox(height: 10),

                    // Title with optimized text rendering
                    Text(
                      _profileTitle,
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3),

                    const SizedBox(height: 20),

                    // Social Links
                    const DynamicSocialLinks(),

                    const SizedBox(height: 40),

                    // Scroll Indicator with optimized animation
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7),
                      size: 40,
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .slideY(
                          begin: 0,
                          end: 0.2,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),
            ),

            // About Section
            const DynamicAboutSection(),

            // Skills Section
            const DynamicSkillsSection(),

            // Projects Section
            const ProjectsSection(),
          ],
        ),
      ),
    );
  }
}
