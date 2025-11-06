import 'dart:typed_data';

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
              Text(   'Scroll each card for more info',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 10 : 12,
                  color: Colors.grey[900]
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
                  childAspectRatio: isMobile ? 0.60 : 0.85,
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
//   void _showEditDialog(BuildContext context, Map<String, dynamic> projectData, String projectId) {
//   final titleController = TextEditingController(text: projectData['title']);
//   final descController = TextEditingController(text: projectData['description']);
//   final githubController = TextEditingController(text: projectData['githubUrl']);
//   final youtubeController = TextEditingController(text: projectData['youtubeUrl']);
//   final playStoreController = TextEditingController(text: projectData['playStoreUrl']);
//   final techController = TextEditingController(
//     text: (projectData['technologies'] as List<dynamic>).join(', '),
//   );

//   Uint8List? updatedImageBytes;
//   String? newImageUrl;

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Edit Project'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: 'Title'),
//               ),
//               TextField(
//                 controller: descController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//               ),
//               TextField(
//                 controller: techController,
//                 decoration: const InputDecoration(labelText: 'Technologies (comma separated)'),
//               ),
//               TextField(
//                 controller: githubController,
//                 decoration: const InputDecoration(labelText: 'GitHub URL'),
//               ),
//               TextField(
//                 controller: youtubeController,
//                 decoration: const InputDecoration(labelText: 'YouTube URL'),
//               ),
//               TextField(
//                 controller: playStoreController,
//                 decoration: const InputDecoration(labelText: 'PlayStore URL'),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final ImagePicker picker = ImagePicker();
//                   final picked = await picker.pickImage(source: ImageSource.gallery);
//                   if (picked != null) {
//                     updatedImageBytes = await picked.readAsBytes();
//                   }
//                 },
//                 icon: const Icon(Icons.image),
//                 label: const Text('Change Image'),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);

//               if (updatedImageBytes != null) {
//                 newImageUrl = await ImageService().uploadImageBytes(updatedImageBytes!);
//               }

//               await FirebaseFirestore.instance
//                   .collection('projects')
//                   .doc(projectId)
//                   .update({
//                 'title': titleController.text,
//                 'description': descController.text,
//                 'technologies': techController.text
//                     .split(',')
//                     .map((e) => e.trim())
//                     .toList(),
//                 'githubUrl': githubController.text,
//                 'youtubeUrl': youtubeController.text,
//                 'playStoreUrl': playStoreController.text,
//                 'imageUrl': newImageUrl ?? projectData['imageUrl'],
//               });

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Project updated successfully!'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             child: const Text('Save Changes'),
//           ),
//         ],
//       );
//     },
//   );
// }
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                minHeight: 240,
              ),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardMaxWidth = constraints.maxWidth;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: cardMaxWidth > 400 ? 220 : 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: !_isValidImageUrl(sanitizedUrl)
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error_outline, color: Colors.red, size: 24),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Invalid image URL',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : Hero(
  tag: 'project-${widget.projectId}',
  child: Container(
    width: double.infinity,
    height: cardMaxWidth > 400 ? 220 : 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey[100], // Background behind image
    ),
    clipBehavior: Clip.antiAlias,
    child: CachedNetworkImage(
      imageUrl: sanitizedUrl,
      fit: BoxFit.contain, // ✅ shows full image (no cropping)
      alignment: Alignment.center, // ✅ always centered
      placeholder: (context, url) => const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 24),
            const SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  ),
),

),
                            // Delete Button remains (unchanged)
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
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 200),
                                        opacity: isHovered ? 1.0 : 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white),
                                                onPressed: () =>
                                                    _showEditDialog(context),
                                                tooltip: 'Edit Project',
                                                padding: const EdgeInsets.all(8),
                                                constraints: const BoxConstraints(),
                                                iconSize: 20,
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.white),
                                                onPressed: () =>
                                                    _deleteProject(context),
                                                tooltip: 'Delete Project',
                                                padding: const EdgeInsets.all(8),
                                                constraints: const BoxConstraints(),
                                                iconSize: 20,
                                              ),
                                            ],
                                          ),
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
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.title,
                                style: GoogleFonts.poppins(
                                  fontSize: cardMaxWidth > 400 ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Description
                              Text(
                                widget.description,
                                style: GoogleFonts.poppins(
                                  fontSize: cardMaxWidth > 400 ? 16 : 14,
                                  color: Colors.black87,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isHovered
                                          ? Theme.of(context).primaryColor.withOpacity(0.1)
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
                                        fontSize: cardMaxWidth > 400 ? 12 : 11,
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
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (widget.playStoreUrl.isNotEmpty)
                                    AnimatedContainer(
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
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          textStyle: TextStyle(
                                            fontSize: cardMaxWidth > 400 ? 13 : 12,
                                            fontWeight: FontWeight.w500),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: isHovered ? 4 : 2,
                                        ),
                                      ),
                                    ),
                                  if (widget.githubUrl.isNotEmpty)
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
                                        label: const Text('Source Code'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isHovered ? Colors.black : Colors.black87,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          textStyle: TextStyle(
                                              fontSize: cardMaxWidth > 400 ? 13 : 12,
                                              fontWeight: FontWeight.w500),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: isHovered ? 4 : 2,
                                        ),
                                      ),
                                    ),
                                  if (widget.githubUrl.isNotEmpty && widget.youtubeUrl.isNotEmpty)
                                    const SizedBox(width: 8),
                                  if (widget.youtubeUrl.isNotEmpty)
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final uri = Uri.parse(widget.youtubeUrl);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          }
                                        },
                                        icon: const Icon(Icons.play_circle_outline, size: 16),
                                        label: const Text('Video'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isHovered ? Colors.red.shade700 : Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          textStyle: TextStyle(
                                              fontSize: cardMaxWidth > 400 ? 13 : 12,
                                              fontWeight: FontWeight.w500),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: isHovered ? 4 : 2,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
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

void _showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: EditProjectForm(
            projectId: widget.projectId,
            projectData: {
              'title': widget.title,
              'description': widget.description,
              'githubUrl': widget.githubUrl,
              'youtubeUrl': widget.youtubeUrl,
              'playStoreUrl': widget.playStoreUrl,
              'technologies': widget.technologies,
              'imageUrl': widget.imageUrl,
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
