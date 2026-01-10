import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/services/portfolio_service.dart';

class SocialLink {
  String platform;
  String url;
  IconData icon;
  Color color;

  SocialLink({
    required this.platform,
    required this.url,
    required this.icon,
    required this.color,
  });
}

class EditSocialLinksForm extends StatefulWidget {
  const EditSocialLinksForm({super.key});

  @override
  State<EditSocialLinksForm> createState() => _EditSocialLinksFormState();
}

class _EditSocialLinksFormState extends State<EditSocialLinksForm> {
  final PortfolioService _portfolioService = PortfolioService();
  bool _isLoading = false;
  
  List<SocialLink> _socialLinks = [
    SocialLink(
      platform: 'GitHub',
      url: '',
      icon: Icons.code,
      color: Colors.black87,
    ),
    SocialLink(
      platform: 'LinkedIn',
      url: '',
      icon: Icons.work,
      color: Colors.blue,
    ),
    SocialLink(
      platform: 'Twitter',
      url: '',
      icon: Icons.alternate_email,
      color: Colors.lightBlue,
    ),
    SocialLink(
      platform: 'Facebook',
      url: '',
      icon: Icons.facebook,
      color: Colors.indigo,
    ),
    SocialLink(
      platform: 'Instagram',
      url: '',
      icon: Icons.camera_alt,
      color: Colors.pink,
    ),
    SocialLink(
      platform: 'Email',
      url: '',
      icon: Icons.email,
      color: Colors.red,
    ),
    SocialLink(
      platform: 'Website',
      url: '',
      icon: Icons.language,
      color: Colors.green,
    ),
  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSocialLinksData();
  }

  void _initializeControllers() {
    for (var link in _socialLinks) {
      _controllers[link.platform] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSocialLinksData() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await _portfolioService.getSocialLinksData();
      if (data != null && data['links'] != null) {
        final List<dynamic> links = data['links'];
        for (var linkData in links) {
          final platform = linkData['platform'] as String;
          final url = linkData['url'] as String;
          
          final index = _socialLinks.indexWhere((link) => link.platform == platform);
          if (index != -1) {
            _socialLinks[index].url = url;
            _controllers[platform]?.text = url;
          }
        }
        setState(() {});
      }
    } catch (e) {
      _showErrorSnackBar('Error loading social links data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSocialLinks() async {
    setState(() => _isLoading = true);

    try {
      final linksData = _socialLinks.map((link) => {
        'platform': link.platform,
        'url': link.url.trim(),
        'icon': link.icon.codePoint.toString(),
        'color': link.color.value.toString(),
      }).where((link) => link['url'].toString().isNotEmpty).toList();

      await _portfolioService.updateSocialLinksData({
        'links': linksData,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      _showSuccessSnackBar('Social links updated successfully');
      Navigator.pop(context);
    } catch (e) {
      _showErrorSnackBar('Error updating social links: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Social Links',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ).animate().fadeIn().slideX(),
        
        const SizedBox(height: 8),
        
        Text(
          'Add or update your social media and contact links. Empty fields will be hidden.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 100)),
        
        const SizedBox(height: 20),
        
        Expanded(
          child: ListView.builder(
            itemCount: _socialLinks.length,
            itemBuilder: (context, index) {
              final link = _socialLinks[index];
              final controller = _controllers[link.platform]!;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: link.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: link.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              link.icon,
                              color: link.color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            link.platform,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Enter ${link.platform.toLowerCase()} URL',
                          prefixIcon: Icon(
                            Icons.link,
                            color: link.color,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        onChanged: (value) {
                          link.url = value;
                        },
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            // Basic URL validation
                            if (!value.startsWith('http://') && !value.startsWith('https://') && link.platform != 'Email') {
                              return 'Please enter a valid URL starting with http:// or https://';
                            }
                            if (link.platform == 'Email' && !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Save Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveSocialLinks,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Save Social Links',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ).animate().fadeIn().slideY(delay: const Duration(milliseconds: 400)),
        ),
      ],
    );
  }
}
