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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not open CV link: $url')),
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
                shadowColor: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.5), // Add shadow with primary color
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

  Widget _buildEducationEntry(String degree, String institution, String years,
      [String? additionalInfo]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$institution, $years',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
          if (additionalInfo != null) ...[
            const SizedBox(height: 4),
            Text(
              additionalInfo,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkExperienceEntry(String title, String company, String years,
      List<String> responsibilities) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$company, $years',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: responsibilities
                .map((resp) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 8, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              resp,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectEntry(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 20.0), // Spacing between project entries
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4), // Spacing between title and description
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateEntry(String title, String issuer) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 12.0), // Spacing between certificate entries
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4), // Spacing between title and issuer
          Text(
            issuer,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoEntry(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 8.0), // Spacing between personal info entries
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8), // Spacing between label and value
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkEntry(
      BuildContext context, String label, String url, IconData iconData) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8.0), // Spacing between link entries
      child: InkWell(
        onTap: () async {
          if (url.isNotEmpty) {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch link: $url')),
              );
            }
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData,
                size: 20, color: Theme.of(context).primaryColor), // Link icon
            const SizedBox(width: 8), // Spacing between icon and label
            Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 8), // Spacing between label and url
            Expanded(
              child: Text(
                url,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.blue[700], // Link color
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
