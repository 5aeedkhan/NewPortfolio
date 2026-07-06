import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(),

          const SizedBox(height: 40),

          // Professional Summary Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Professional Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                      .animate()
                      .fadeIn()
                      .slideX(delay: const Duration(milliseconds: 100)),
                  const SizedBox(height: 16),
                  Text(
                    'I am a passionate and detail-oriented Computer Science graduate with hands-on experience building cross-platform mobile apps using Flutter and Dart. I have worked through the full app development cycle — from gathering requirements and designing clean, user-friendly interfaces to integrating APIs and deploying functional, high-performing apps. I am well-versed in using Firebase, REST APIs, and various third-party tools to create solid mobile solutions. Currently, I am working as a Flutter Developer at IT Artificer, while also teaching as a Lecturer at KPIMS. This mix of development and teaching lets me apply my technical skills while helping others grow, which I genuinely enjoy.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  )
                      .animate()
                      .fadeIn()
                      .slideX(delay: const Duration(milliseconds: 150)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40), // Spacing before button

          // View Full CV Button
          Center(
            // Center the button
            child: ElevatedButton.icon(
              onPressed: () async {
                const url =
                    'https://drive.google.com/file/d/19CYzti5pEICeUtLLjVyIawMiZra8Q3vT/view?usp=sharing';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open CV link.')),
                  );
                }
              },
              icon: const Icon(Icons.description,
                  size: 24), // Changed icon and size
              label: Text('View Full CV',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w600)), // Increased font size and weight
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16), // Increased padding
                backgroundColor:
                    Theme.of(context).primaryColor, // Use primary color
                foregroundColor: Colors.white, // White text
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // More rounded corners
                ),
                elevation: 5, // Increased elevation for a more prominent look
                shadowColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            )
                .animate()
                .fadeIn()
                .slideY(delay: const Duration(milliseconds: 300)),
          ),
        ],
      ),
    );
  }
}
