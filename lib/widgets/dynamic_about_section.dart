import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/services/portfolio_service.dart';

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
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
              padding: const EdgeInsets.all(24.0),
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
                    _summary,
                    textAlign: TextAlign.justify,
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

          const SizedBox(height: 40),

          // View Full CV Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_cvUrl.isNotEmpty) {
                  final uri = Uri.parse(_cvUrl);
                  final canLaunch = await canLaunchUrl(uri);
                  if (!context.mounted) {
                    return;
                  }
                  if (canLaunch) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Could not open CV link: $_cvUrl')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.description, size: 24),
              label: Text(_cvTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
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
