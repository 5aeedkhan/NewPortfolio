import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SocialLinks extends StatelessWidget {
  const SocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          context: context,
          icon: Icons.email,
          url: 'ms4eedkhan@gmail.com',
          type: 'email',
          delay: 0,
        ),
        _buildSocialIcon(
          context: context,
          icon: FontAwesomeIcons.linkedin,
          url: 'https://linkedin.com/in/s4eedkhan',
          type: 'url',
          delay: 1,
        ),
        _buildSocialIcon(
          context: context,
          icon: FontAwesomeIcons.github,
          url: 'https://github.com/5aeedkhan',
          type: 'url',
          delay: 2,
        ),
        _buildSocialIcon(
          context: context,
          icon: FontAwesomeIcons.whatsapp,
          url: '+923359350658',
          type: 'whatsapp',
          delay: 3,
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required BuildContext context,
    required IconData icon,
    required String url,
    required String type,
    required int delay,
  }) {
    String finalUrl;
    if (type == 'email') {
      finalUrl = kIsWeb ? 'https://mail.google.com/mail/?view=compose&fs=1&to=$url' : 'mailto:$url';
    } else if (type == 'whatsapp') {
      finalUrl = kIsWeb ? 'https://wa.me/$url' : 'whatsapp://send?phone=$url';
    } else {
      finalUrl = url;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: () async {
          final uri = Uri.parse(finalUrl);
          debugPrint('Attempting to launch link: $finalUrl');
          if (await canLaunchUrl(uri)) {
            debugPrint('Link can be launched.');
            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              debugPrint('Link launched successfully.');
            } catch (e) {
              debugPrint('Error launching link: $e');
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch link: ${e.toString()}')),
              );
            }
          } else {
            debugPrint('Link cannot be launched.');
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not launch link.')),
            );
          }
        },
      ).animate().fadeIn(delay: Duration(milliseconds: delay * 200)).scale(
            delay: Duration(milliseconds: delay * 200),
            duration: const Duration(milliseconds: 400),
          ),
    );
  }
}
