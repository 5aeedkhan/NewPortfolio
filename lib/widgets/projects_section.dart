import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/login_screen.dart';
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
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
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
                                  child: const SingleChildScrollView(
                                    padding: EdgeInsets.all(16),
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
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ).animate().fadeIn().scale(),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                          },
                          icon: const Icon(Icons.logout, size: 18),
                          tooltip: 'Logout',
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ).animate().fadeIn().scale(),
                      ],
                    );
                  }
                  return ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginScreen(),
                      );
                    },
                    icon: const Icon(Icons.login, size: 20),
                    label: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor:
                          Theme.of(context).primaryColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ).animate().fadeIn().slideX();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('projects').get(),
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
                print('Firestore error: ${snapshot.error}');
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
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                  crossAxisSpacing: isMobile ? 0 : 16,
                  mainAxisSpacing: isMobile ? 16 : 16,
                  childAspectRatio: isMobile ? 0.75 : 0.85,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final imageUrl = data['imageUrl'] ?? '';
                  return ProjectCard(
                    title: data['title'] ?? '',
                    description: data['description'] ?? '',
                    imageUrl: imageUrl,
                    technologies: List<String>.from(data['technologies'] ?? []),
                    githubUrl: data['githubUrl'] ?? '',
                    playStoreUrl: data['githubUrl'] ?? '',
                    youtubeUrl: data['youtubeUrl'] ?? '',
                    demoUrl: data['demoUrl'] ?? '',
                    projectId: doc.id,
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
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final sanitizedUrl = _sanitizeImageUrl(widget.imageUrl);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(isHovered ? 0.05 : 0)
          ..rotateY(isHovered ? 0.05 : 0),
        child: Card(
          elevation: isHovered ? 12 : 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: isMobile ? 500 : 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isHovered
                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section with Delete Button
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: isMobile ? 200 : 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: !_isValidImageUrl(sanitizedUrl)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 24),
                                const SizedBox(height: 8),
                                Text(
                                  'Invalid image URL',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Hero(
                              tag: 'project-${widget.projectId}',
                              child: CachedNetworkImage(
                                imageUrl: sanitizedUrl,
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: Colors.red, size: 24),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    // Delete Button (only visible when logged in)
                    StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Positioned(
                            top: 8,
                            right: 8,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isHovered ? 1.0 : 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
                                  onPressed: () => _deleteProject(context),
                                  tooltip: 'Delete Project',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Scrollable Description
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              widget.description,
                              style: GoogleFonts.poppins(
                                fontSize: isMobile ? 14 : 13,
                                color: Colors.grey[800],
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Technologies
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.technologies.map((tech) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
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
                                  fontSize: isMobile ? 12 : 11,
                                  color: isHovered
                                      ? Theme.of(context).primaryColor
                                      : Colors.blueGrey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (widget.playStoreUrl.isNotEmpty)
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final uri = Uri.parse(widget.playStoreUrl);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    },
                                    icon: const Icon(Icons.play_arrow, size: 16),
                                    label: const Text('Live App'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isHovered
                                          ? Colors.blue
                                          : Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: isMobile ? 13 : 12,
                                          fontWeight: FontWeight.w500),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: isHovered ? 4 : 2,
                                    ),
                                  ),
                                ),
                              ),
                            // if (widget.githubUrl.isNotEmpty &&
                            //     widget.youtubeUrl.isNotEmpty)
                            const SizedBox(width: 8),
                            if (widget.githubUrl.isNotEmpty)
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final uri = Uri.parse(widget.githubUrl);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    },
                                    icon: const Icon(Icons.code, size: 16),
                                    label: const Text('Source Code'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isHovered
                                          ? Colors.black
                                          : Colors.black87,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: isMobile ? 13 : 12,
                                          fontWeight: FontWeight.w500),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: isHovered ? 4 : 2,
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.githubUrl.isNotEmpty &&
                                widget.youtubeUrl.isNotEmpty)
                              const SizedBox(width: 8),
                            if (widget.youtubeUrl.isNotEmpty)
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final uri = Uri.parse(widget.youtubeUrl);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    },
                                    icon: const Icon(Icons.play_circle_outline,
                                        size: 16),
                                    label: const Text('Video'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isHovered
                                          ? Colors.red.shade700
                                          : Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: isMobile ? 13 : 12,
                                          fontWeight: FontWeight.w500),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: isHovered ? 4 : 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
      print('Invalid URL format: $url');
      return false;
    }
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
