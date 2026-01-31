import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:portfolio/widgets/edit_project_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_project_form.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Animation
          LayoutBuilder(
            builder: (context, constraints) {
              final isVerySmallScreen = constraints.maxWidth < 400;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isVerySmallScreen)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Projects',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 22 : 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn().slideX(),
                        Text(
                          'Scroll each card for more info',
                          style: GoogleFonts.poppins(
                              fontSize: isMobile ? 10 : 12,
                              color: Colors.grey[900]),
                        ).animate().fadeIn().slideX(),
                        StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.85,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: const SingleChildScrollView(
                                          padding: EdgeInsets.all(20),
                                          child: AddProjectForm(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Project',
                                    style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                  shadowColor: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ).animate().fadeIn().scale();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  if (isVerySmallScreen)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Projects',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn().slideX(),
                        const SizedBox(height: 8),
                        Text(
                          'Scroll each card for more info',
                          style: GoogleFonts.poppins(
                              fontSize: isMobile ? 9 : 11,
                              color: Colors.grey[900]),
                        ).animate().fadeIn().slideX(),
                        const SizedBox(height: 8),
                        StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.85,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.1),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: const SingleChildScrollView(
                                            padding: EdgeInsets.all(20),
                                            child: AddProjectForm(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Add Project',
                                      style: TextStyle(fontSize: 11)),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 3,
                                    shadowColor: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ).animate().fadeIn().scale(),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('projects').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(
                        'Loading projects...',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale();
              }

              if (snapshot.hasError) {
                debugPrint('Firestore error: ${snapshot.error}');
                return Center(
                  child: Column(
                    children: [
                      Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.red[400],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          (context as Element).markNeedsBuild();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No projects available',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ).animate().fadeIn().scale();
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 3,
                  crossAxisSpacing: isMobile ? 12 : 16,
                  mainAxisSpacing: isMobile ? 16 : 20,
                  childAspectRatio: isMobile ? 0.8 : 0.8,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data();
                  final imageUrl = data['imageUrl'] ?? '';
                  return ProjectCard(
                    title: data['title'] ?? '',
                    description: data['description'] ?? '',
                    imageUrl: imageUrl,
                    technologies: List<String>.from(data['technologies'] ?? []),
                    githubUrl: data['githubUrl'] ?? '',
                    playStoreUrl: data['playStoreUrl'] ?? '',
                    youtubeUrl: data['youtubeUrl'] ?? '',
                    demoUrl: data['demoUrl'] ?? '',
                    projectId: doc.id,
                    isAdmin: true,
                  )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 100 * index),
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        curve: Curves.easeOutQuad,
                      );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String githubUrl;
  final String youtubeUrl;
  final String playStoreUrl;
  final String demoUrl;
  final String projectId;
  final bool isAdmin;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.githubUrl,
    required this.youtubeUrl,
    required this.demoUrl,
    required this.projectId,
    required this.playStoreUrl,
    required this.isAdmin,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;
  bool isPulsing = false;
  bool showGesture = false;

  void _showProjectDetails() {
    setState(() {
      isPulsing = true;
    });

    // Add a small delay before showing dialog to let animation play
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isPulsing = false;
        });
        showDialog(
          context: context,
          builder: (context) => ProjectDetailDialog(
            title: widget.title,
            description: widget.description,
            imageUrl: widget.imageUrl,
            technologies: widget.technologies,
            githubUrl: widget.githubUrl,
            youtubeUrl: widget.youtubeUrl,
            playStoreUrl: widget.playStoreUrl,
            demoUrl: widget.demoUrl,
            projectId: widget.projectId,
            isAdmin: widget.isAdmin,
            onDelete: () => _deleteProject(context),
            onEdit: () => _showEditDialog(context),
          ),
        );
      }
    });
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      showGesture = true;
      isHovered = true;
    });

    // Hide gesture after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showGesture = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sanitizedUrl = _sanitizeImageUrl(widget.imageUrl);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTap: _showProjectDetails,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: isHovered ? 12 : 8,
                offset: const Offset(0, 4),
              ),
              if (isPulsing)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
            ],
            border: Border.all(
              color: isPulsing
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.6)
                  : isHovered
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                      : Colors.transparent,
              width: isPulsing ? 3 : 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Image
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _isValidImageUrl(sanitizedUrl)
                        ? CachedNetworkImage(
                            imageUrl: sanitizedUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          ),
                  ),
                ),
              ),
              // Project Title and Buttons
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Project Title
                      Flexible(
                        child: Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Animated Tap Gesture Icon
                      if (showGesture || isHovered)
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            builder: (context, value, child) {
                              return Icon(
                                Icons.touch_app,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.6),
                                size: isMobile ? 22 : 26,
                              )
                                  .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                  )
                                  .scale(
                                    begin: const Offset(1.0, 1.0),
                                    end: const Offset(1.1, 1.1),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                            },
                          ),
                        ),
                      const SizedBox(height: 0),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildActionButtons(isMobile),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(
              onPlay: (controller) => isPulsing ? controller.repeat() : null,
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end:
                  isPulsing ? const Offset(1.05, 1.05) : const Offset(1.0, 1.0),
              duration: Duration(milliseconds: isPulsing ? 800 : 200),
              curve: Curves.easeInOut,
              alignment: Alignment.center,
            ),
      ),
    );
  }

  List<Widget> _buildActionButtons(bool isMobile) {
    List<Widget> buttons = [];

    if (widget.playStoreUrl.isNotEmpty) {
      buttons.add(
        _buildIconButton(
          Icons.play_arrow,
          'Live',
          () async {
            final uri = Uri.parse(widget.playStoreUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          Colors.blue,
          isMobile,
        ),
      );
    }

    if (widget.githubUrl.isNotEmpty) {
      buttons.add(
        _buildIconButton(
          Icons.code,
          'Code',
          () async {
            final uri = Uri.parse(widget.githubUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          Colors.black,
          isMobile,
        ),
      );
    }

    if (widget.youtubeUrl.isNotEmpty) {
      buttons.add(
        _buildIconButton(
          Icons.play_circle_outline,
          'Video',
          () async {
            final uri = Uri.parse(widget.youtubeUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          Colors.red,
          isMobile,
        ),
      );
    }

    return buttons;
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed,
      Color color, bool isMobile) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: isMobile ? 10 : 12),
          label: Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 8 : 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 2 : 4,
              vertical: isMobile ? 3 : 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            minimumSize: Size(0, isMobile ? 24 : 28),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }

  String _sanitizeImageUrl(String url) {
    if (url.startsWith('@')) {
      url = url.substring(1);
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  bool _isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      debugPrint('Invalid URL format: $url');
      return false;
    }
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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
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
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
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

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Project deleted successfully',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error deleting project: $e',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }
}

class ProjectDetailDialog extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String githubUrl;
  final String youtubeUrl;
  final String playStoreUrl;
  final String demoUrl;
  final String projectId;
  final bool isAdmin;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ProjectDetailDialog({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.githubUrl,
    required this.youtubeUrl,
    required this.playStoreUrl,
    required this.demoUrl,
    required this.projectId,
    required this.isAdmin,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<ProjectDetailDialog> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final sanitizedUrl = _sanitizeImageUrl(widget.imageUrl);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? screenWidth : screenWidth * 0.8,
          maxHeight: screenHeight * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Header with close button
            _buildHeader(context, isMobile),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Image with animation
                    if (_isValidImageUrl(sanitizedUrl))
                      _buildProjectImage(sanitizedUrl, isMobile),

                    // Description with animation
                    if (widget.description.isNotEmpty) ...[
                      _buildSectionTitle('Description', isMobile),
                      const SizedBox(height: 12),
                      _buildDescription(isMobile),
                      const SizedBox(height: 24),
                    ],

                    // Technologies with animation
                    if (widget.technologies.isNotEmpty) ...[
                      _buildSectionTitle('Technologies', isMobile),
                      const SizedBox(height: 16),
                      _buildTechnologies(isMobile),
                      const SizedBox(height: 24),
                    ],

                    // Action Buttons with animation
                    if (_hasAnyLinks()) ...[
                      _buildSectionTitle('Links', isMobile),
                      const SizedBox(height: 16),
                      _buildActionButtons(isMobile),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().scale().fadeIn(),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn().slideX(begin: -0.3),
          ),
          Row(
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        _buildHeaderButton(
                          Icons.edit,
                          'Edit Project',
                          () {
                            Navigator.of(context).pop();
                            widget.onEdit?.call();
                          },
                          Colors.white,
                        ).animate().fadeIn().slideX(begin: 0.3),
                        const SizedBox(width: 8),
                        _buildHeaderButton(
                          Icons.delete,
                          'Delete Project',
                          () {
                            Navigator.of(context).pop();
                            widget.onDelete?.call();
                          },
                          Colors.red.shade300,
                        ).animate().fadeIn().slideX(begin: 0.3),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 8),
              _buildHeaderButton(
                Icons.close,
                'Close',
                () => Navigator.of(context).pop(),
                Colors.white,
              ).animate().fadeIn().slideX(begin: 0.3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(
      IconData icon, String tooltip, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20),
        tooltip: tooltip,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildProjectImage(String sanitizedUrl, bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 200 : 250,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[100]!,
            Colors.grey[200]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: sanitizedUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[200]!,
                  Colors.grey[300]!,
                ],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[400]!,
                ],
              ),
            ),
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.red, size: 40),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().scale(delay: 200.milliseconds);
  }

  Widget _buildSectionTitle(String title, bool isMobile) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: isMobile ? 18 : 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ).animate().fadeIn().slideY(begin: 0.3, delay: 300.milliseconds);
  }

  Widget _buildDescription(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        widget.description,
        style: GoogleFonts.poppins(
          fontSize: isMobile ? 14 : 16,
          color: Colors.black54,
          height: 1.6,
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3, delay: 400.milliseconds);
  }

  Widget _buildTechnologies(bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.technologies.map((tech) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                Theme.of(context).primaryColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            tech,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 12 : 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn().slideY(begin: 0.3, delay: 500.milliseconds);
  }

  Widget _buildActionButtons(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        if (widget.playStoreUrl.isNotEmpty)
          _buildActionButton(
            Icons.play_arrow,
            'Live App',
            Colors.blue,
            () async {
              final uri = Uri.parse(widget.playStoreUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            isMobile,
          ),
        if (widget.githubUrl.isNotEmpty)
          _buildActionButton(
            Icons.code,
            'Source Code',
            Colors.black,
            () async {
              final uri = Uri.parse(widget.githubUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            isMobile,
          ),
        if (widget.youtubeUrl.isNotEmpty)
          _buildActionButton(
            Icons.play_circle_outline,
            'Video',
            Colors.red,
            () async {
              final uri = Uri.parse(widget.youtubeUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            isMobile,
          ),
        if (widget.demoUrl.isNotEmpty)
          _buildActionButton(
            Icons.link,
            'Demo',
            Colors.green,
            () async {
              final uri = Uri.parse(widget.demoUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            isMobile,
          ),
      ],
    ).animate().fadeIn().slideY(begin: 0.3, delay: 600.milliseconds);
  }

  Widget _buildActionButton(IconData icon, String label, Color color,
      VoidCallback onPressed, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: isMobile ? 18 : 20),
          label: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 24,
              vertical: isMobile ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: color.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  bool _hasAnyLinks() {
    return widget.playStoreUrl.isNotEmpty ||
        widget.githubUrl.isNotEmpty ||
        widget.youtubeUrl.isNotEmpty ||
        widget.demoUrl.isNotEmpty;
  }

  String _sanitizeImageUrl(String url) {
    if (url.startsWith('@')) {
      url = url.substring(1);
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  bool _isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

double get screenHeight {
  return WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.height /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
}
