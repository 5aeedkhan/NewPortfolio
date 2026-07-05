import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';

class SocialLinkData {
  final String platform;
  final String url;
  final IconData icon;
  final Color color;

  SocialLinkData({
    required this.platform,
    required this.url,
    required this.icon,
    required this.color,
  });
}

class DynamicSocialLinks extends StatefulWidget {
  const DynamicSocialLinks({super.key});

  @override
  State<DynamicSocialLinks> createState() => _DynamicSocialLinksState();
}

class _DynamicSocialLinksState extends State<DynamicSocialLinks> {
  final PortfolioService _portfolioService = PortfolioService();
  List<SocialLinkData> _socialLinks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSocialLinks();
  }

  Future<void> _loadSocialLinks() async {
    try {
      final data = await _portfolioService.getSocialLinksData();
      if (data != null && data['links'] != null) {
        final List<dynamic> links = data['links'];
        final socialLinks = links
            .map((linkData) {
              return SocialLinkData(
                platform: linkData['platform'] ?? '',
                url: linkData['url'] ?? '',
                icon: _getIconFromCodePoint(
                    int.tryParse(linkData['icon'] ?? '0') ?? 0),
                color:
                    Color(int.tryParse(linkData['color'] ?? '0') ?? 0xFF000000),
              );
            })
            .where((link) => link.url.isNotEmpty)
            .toList();

        setState(() {
          _socialLinks = socialLinks;
          _isLoading = false;
        });
      } else {
        // Use default social links if no data found
        setState(() {
          _socialLinks = _getDefaultSocialLinks();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading social links: $e');
      setState(() {
        _socialLinks = _getDefaultSocialLinks();
        _isLoading = false;
      });
    }
  }

  List<SocialLinkData> _getDefaultSocialLinks() {
    return [
      SocialLinkData(
        platform: 'Email',
        url: 'ms4eedkhan@gmail.com',
        icon: Icons.email,
        color: Colors.red,
      ),
      SocialLinkData(
        platform: 'LinkedIn',
        url: 'https://linkedin.com/in/s4eedkhan',
        icon: FontAwesomeIcons.linkedin,
        color: Colors.blue,
      ),
      SocialLinkData(
        platform: 'GitHub',
        url: 'https://github.com/5aeedkhan',
        icon: FontAwesomeIcons.github,
        color: Colors.black87,
      ),
      SocialLinkData(
        platform: 'WhatsApp',
        url: '+923359350658',
        icon: FontAwesomeIcons.whatsapp,
        color: Colors.green,
      ),
    ];
  }

  IconData _getIconFromCodePoint(int codePoint) {
    switch (codePoint) {
      case 0xe0be:
        return Icons.email;
      case 0xf0e1:
        return Icons.link;
      case 0xf0c1:
        return Icons.work;
      case 0xf19d:
        return FontAwesomeIcons.linkedin;
      case 0xf09b:
        return FontAwesomeIcons.github;
      case 0xf232:
        return FontAwesomeIcons.whatsapp;
      case 0xf08c:
        return FontAwesomeIcons.facebook;
      case 0xf16d:
        return FontAwesomeIcons.instagram;
      case 0xf0ac:
        return FontAwesomeIcons.language;
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _socialLinks.asMap().entries.map((entry) {
        final index = entry.key;
        final link = entry.value;
        return _buildSocialIcon(
          context: context,
          icon: link.icon,
          url: link.url,
          platform: link.platform,
          delay: index,
        );
      }).toList(),
    );
  }

  Widget _buildSocialIcon({
    required BuildContext context,
    required IconData icon,
    required String url,
    required String platform,
    required int delay,
  }) {
    String finalUrl;
    if (platform.toLowerCase() == 'email') {
      finalUrl = kIsWeb
          ? 'https://mail.google.com/mail/?view=compose&fs=1&to=$url'
          : 'mailto:$url';
    } else if (platform.toLowerCase() == 'whatsapp') {
      finalUrl = kIsWeb ? 'https://wa.me/$url' : 'whatsapp://send?phone=$url';
    } else {
      finalUrl = url;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: _NeonSocialPill(
        icon: icon,
        url: finalUrl,
        platform: platform,
        delay: delay,
      ),
    );
  }
}

class _NeonSocialPill extends StatefulWidget {
  final IconData icon;
  final String url;
  final String platform;
  final int delay;

  const _NeonSocialPill({
    required this.icon,
    required this.url,
    required this.platform,
    required this.delay,
  });

  @override
  State<_NeonSocialPill> createState() => _NeonSocialPillState();
}

class _NeonSocialPillState extends State<_NeonSocialPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          final canLaunch = await canLaunchUrl(uri);
          if (!context.mounted) return;
          if (canLaunch) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not launch link.')),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.neonCyan.withValues(alpha: 0.15)
                : AppTheme.glassBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.neonCyan.withValues(alpha: 0.5)
                  : AppTheme.glassBorder,
              width: 1,
            ),
            boxShadow: _isHovered
                ? AppTheme.neonGlow(color: AppTheme.neonCyan, blurRadius: 12)
                : [],
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? AppTheme.neonCyan : AppTheme.textPrimary,
            size: 22,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay * 150))
        .scale(
          delay: Duration(milliseconds: widget.delay * 150),
          duration: const Duration(milliseconds: 400),
          begin: const Offset(0.5, 0.5),
        );
  }
}
