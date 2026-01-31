import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/widgets/edit_profile_form.dart';
import 'package:portfolio/widgets/edit_about_form.dart';
import 'package:portfolio/widgets/edit_skills_form.dart';
import 'package:portfolio/widgets/edit_social_links_form.dart';
import 'package:portfolio/widgets/edit_cv_form.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final PortfolioService _portfolioService = PortfolioService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Beautiful Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Panel',
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 24 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Manage your portfolio content',
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 14 : 16,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Management Cards
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  child: GridView.count(
                    crossAxisCount: isMobile ? 1 : 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.0,
                    children: [
                      _buildManagementCard(
                        context,
                        'Profile Information',
                        'Update your name, title, and profile picture',
                        Icons.person,
                        Colors.blue,
                        [
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                        ],
                        () => _showEditDialog(context, 'Profile Information',
                            const EditProfileForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'About Me',
                        'Edit your professional summary and bio',
                        Icons.info,
                        Colors.green,
                        [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                        () => _showEditDialog(
                            context, 'About Me', const EditAboutForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Skills & Tools',
                        'Manage your technical skills and competencies',
                        Icons.build,
                        Colors.orange,
                        [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                        () => _showEditDialog(
                            context, 'Skills & Tools', const EditSkillsForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Social Links',
                        'Update your social media and contact links',
                        Icons.link,
                        Colors.purple,
                        [
                          Colors.purple.shade400,
                          Colors.purple.shade600,
                        ],
                        () => _showEditDialog(context, 'Social Links',
                            const EditSocialLinksForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'CV/Resume',
                        'Update your CV link and download button',
                        Icons.description,
                        Colors.red,
                        [
                          Colors.red.shade400,
                          Colors.red.shade600,
                        ],
                        () => _showEditDialog(
                            context, 'CV/Resume', const EditCVForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Analytics',
                        'View portfolio visits and last activity',
                        Icons.insights,
                        Colors.teal,
                        [
                          Colors.teal.shade400,
                          Colors.teal.shade600,
                        ],
                        () => _showAnalyticsDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    List<Color> gradientColors,
    VoidCallback onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    color.withValues(alpha: 0.05),
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with gradient background
                  Container(
                    padding: EdgeInsets.all(isMobile ? 8 : 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: isMobile ? 20 : 24,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 10 : 11,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Edit button
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 9 : 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: isMobile ? 8 : 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        );
  }

  void _showEditDialog(BuildContext context, String title, Widget form) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                        title,
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
                  child: form,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
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
                    const Icon(Icons.insights, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Analytics',
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
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _portfolioService.watchVisitStats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load analytics',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }

                    final data = snapshot.data?.data() ?? {};
                    final total = (data['total'] ?? 0) as num;
                    final lastVisit = data['lastVisit'];
                    String lastVisitText = 'Never';
                    if (lastVisit is Timestamp) {
                      lastVisitText = lastVisit.toDate().toString();
                    }

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Visits',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            total.toStringAsFixed(0),
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Last Visit',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lastVisitText,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Recent Visits',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: _portfolioService.watchVisitHistory(),
                              builder: (context, historySnapshot) {
                                if (historySnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (historySnapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Failed to load visit history',
                                      style:
                                          GoogleFonts.poppins(color: Colors.red),
                                    ),
                                  );
                                }

                                final visits = historySnapshot.data?.docs ?? [];
                                if (visits.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No visits yet',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  itemCount: visits.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final visitData = visits[index].data();
                                    final platform =
                                        (visitData['platform'] ?? 'Unknown')
                                            as String;
                                    final visitedAt = visitData['visitedAt'];
                                    String visitedAtText = 'Unknown time';
                                    if (visitedAt is Timestamp) {
                                      visitedAtText =
                                          visitedAt.toDate().toString();
                                    }

                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.public,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  platform,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  visitedAtText,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
