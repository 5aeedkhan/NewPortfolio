import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portfolio/services/image_service.dart';
import 'package:portfolio/widgets/edit_project_form.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/login_screen.dart';

class ProjectCard extends StatefulWidget {
  final String projectId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String githubUrl;
  final String youtubeUrl;
  final String playStoreUrl;
  final Color color;

  const ProjectCard({
    super.key,
    required this.projectId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.githubUrl,
    required this.youtubeUrl,
    required this.playStoreUrl,
    required this.color,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardMaxWidth = isMobile ? screenWidth * 0.9 : 300;

    return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Card(
            elevation: isHovered ? 12 : 6,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    widget.color.withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Image with 3D Effect
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Main Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(18)),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.imageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  widget.color),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.person,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),

                                // Gradient Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          widget.color.withOpacity(0.0),
                                          widget.color.withOpacity(0.1),
                                          widget.color.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(18)),
                                    ),
                                  ),
                                ),

                                // Shimmer Effect on Hover
                                if (isHovered)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(18)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Title with Glow Effect
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.color.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.title,
                              style: GoogleFonts.poppins(
                                fontSize: cardMaxWidth > 400 ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Description with Fade In
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: Text(
                              widget.description,
                              style: GoogleFonts.poppins(
                                fontSize: cardMaxWidth > 400 ? 16 : 14,
                                color: Colors.black87,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Technologies with Floating Animation
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, -10 * (1 - value)),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: widget.technologies.map((tech) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOutBack,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10 + 4 * value,
                                        vertical: 4 + 2 * value,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isHovered
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1)
                                            : Colors.blueGrey[50],
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: isHovered
                                              ? Theme.of(context).primaryColor
                                              : Colors.blueGrey.shade100,
                                        ),
                                      ),
                                      child: Text(
                                        tech,
                                        style: GoogleFonts.poppins(
                                          fontSize:
                                              cardMaxWidth > 400 ? 13 : 12,
                                          color: isHovered
                                              ? Theme.of(context).primaryColor
                                              : Colors.blueGrey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Action Buttons with Scale Animation
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // GitHub Button with Pulse Animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final uri = Uri.parse(widget.githubUrl);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  },
                                  icon: const Icon(Icons.code, size: 16),
                                  label: Text(
                                    'Code',
                                    style: GoogleFonts.poppins(
                                      fontSize: cardMaxWidth > 400 ? 11 : 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: isHovered ? 6 : 2,
                                  ),
                                ),
                              )
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true))
                                  .shimmer(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    color: Colors.white,
                                  ),

                              if (widget.githubUrl.isNotEmpty &&
                                  widget.youtubeUrl.isNotEmpty)
                                const SizedBox(width: 8),

                              // YouTube Button with Rotation Animation
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 2000),
                                builder: (context, value, child) {
                                  return Transform.rotate(
                                      angle: -0.1 +
                                          0.1 * math.sin(value * 2 * math.pi),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final uri =
                                                Uri.parse(widget.youtubeUrl);
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri);
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.play_circle_outline,
                                              size: 16),
                                          label: Text(
                                            'Video',
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  cardMaxWidth > 400 ? 11 : 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: isHovered ? 6 : 2,
                                          ),
                                        ),
                                      ));
                                },
                              ).animate(
                                  onPlay: (controller) => controller.repeat()),

                              // Edit Button with Slide Animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutBack,
                                child: IconButton(
                                  onPressed: () => _showEditDialog(context),
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.deepOrange
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 20),
                                  ),
                                  tooltip: 'Edit Project',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                ),
                              ).animate().slideX(begin: 0.2),

                              // Delete Button with Shake Animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: IconButton(
                                  onPressed: () => _deleteProject(context),
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.red.shade700
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white, size: 20),
                                  ),
                                  tooltip: 'Delete Project',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                ),
                              ).animate().shake(
                                    hz: 5,
                                    curve: Curves.easeInOut,
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn().scale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuad,
              ),
        ));
  }

  String _sanitizeImageUrl(String url) {
    if (url.startsWith('@')) {
      url = url.substring(1);
    }
    return url;
  }

  Future<bool> _canLaunchUrl(String url) async {
    if (url.isEmpty) return false;
    final uri = Uri.parse(url);
    return await canLaunchUrl(uri);
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Project',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: EditProjectForm(
                    projectId: widget.projectId,
                    projectData: {
                      'title': widget.title,
                      'description': widget.description,
                      'imageUrl': widget.imageUrl,
                      'technologies': widget.technologies,
                      'githubUrl': widget.githubUrl,
                      'youtubeUrl': widget.youtubeUrl,
                      'playStoreUrl': widget.playStoreUrl,
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteProject(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Project',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this project?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting project: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
