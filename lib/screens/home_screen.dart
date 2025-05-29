import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/widgets/social_links.dart';
import 'package:portfolio/widgets/about_section.dart';
import 'package:portfolio/widgets/projects_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: MediaQuery.of(context).size.height,
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
                    // Profile Image
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          'https://i.ibb.co/P7rHjyV/Whats-App-Image-2025-05-16-at-9-39-19-AM.jpg',
                          width: 190,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 100);
                          },
                        ),
                      ),
                    ).animate().fadeIn().scale(),

                    const SizedBox(height: 30),

                    // Name
                    Text(
                      'Muhammad Saeed Khan',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3),

                    const SizedBox(height: 10),

                    // Title
                    Text(
                      'Mobile App Developer',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3),

                    const SizedBox(height: 20),

                    // Social Links
                    const SocialLinks(),

                    const SizedBox(height: 40),

                    // Scroll Indicator
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
            const AboutSection(),

            // Projects Section
            const ProjectsSection(),
          ],
        ),
      ),
    );
  }
}
