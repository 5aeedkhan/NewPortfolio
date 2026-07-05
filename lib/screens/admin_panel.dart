import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/edit_profile_form.dart';
import 'package:portfolio/widgets/edit_about_form.dart';
import 'package:portfolio/widgets/edit_skills_form.dart';
import 'package:portfolio/widgets/edit_social_links_form.dart';
import 'package:portfolio/widgets/edit_cv_form.dart';
import 'package:portfolio/widgets/edit_experience_form.dart';
import 'package:portfolio/widgets/edit_hero_stats_form.dart';

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
      backgroundColor: AppTheme.bgDarkest,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.bgDarkest,
              AppTheme.bgDark,
              AppTheme.bgCard,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                decoration: BoxDecoration(
                  gradient: AppTheme.neonLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: AppTheme.neonGlow(
                    color: AppTheme.neonCyan,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.bgDarkest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: AppTheme.bgDarkest,
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
                                  color: AppTheme.bgDarkest,
                                ),
                              ),
                              Text(
                                'Manage your portfolio content',
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 14 : 16,
                                  color: AppTheme.bgDarkest.withValues(alpha: 0.8),
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
                              color: AppTheme.bgDarkest.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: AppTheme.bgDarkest,
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
                        AppTheme.neonCyan,
                        [AppTheme.neonCyan, AppTheme.neonBlue],
                        () => _showEditDialog(context, 'Profile Information',
                            const EditProfileForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'About Me',
                        'Edit your professional summary and bio',
                        Icons.info,
                        AppTheme.neonGreen,
                        [AppTheme.neonGreen, AppTheme.neonCyan],
                        () => _showEditDialog(
                            context, 'About Me', const EditAboutForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Skills & Tools',
                        'Manage your technical skills and competencies',
                        Icons.build,
                        AppTheme.neonPurple,
                        [AppTheme.neonPurple, AppTheme.neonPink],
                        () => _showEditDialog(
                            context, 'Skills & Tools', const EditSkillsForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Social Links',
                        'Update your social media and contact links',
                        Icons.link,
                        AppTheme.neonPink,
                        [AppTheme.neonPink, AppTheme.neonPurple],
                        () => _showEditDialog(context, 'Social Links',
                            const EditSocialLinksForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'CV/Resume',
                        'Update your CV link and download button',
                        Icons.description,
                        AppTheme.neonBlue,
                        [AppTheme.neonBlue, AppTheme.neonCyan],
                        () => _showEditDialog(
                            context, 'CV/Resume', const EditCVForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Experience',
                        'Add, edit, or remove work experience timeline',
                        Icons.work_history,
                        AppTheme.neonGreen,
                        [AppTheme.neonGreen, AppTheme.neonCyan],
                        () => _showEditDialog(
                            context, 'Experience', const EditExperienceForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Hero Stats',
                        'Edit the animated stats shown in hero section',
                        Icons.bar_chart,
                        AppTheme.neonPurple,
                        [AppTheme.neonPurple, AppTheme.neonPink],
                        () => _showEditDialog(
                            context, 'Hero Stats', const EditHeroStatsForm()),
                      ),
                      _buildManagementCard(
                        context,
                        'Messages',
                        'View contact form submissions',
                        Icons.mail,
                        AppTheme.neonGreen,
                        [AppTheme.neonGreen, AppTheme.neonBlue],
                        () => _showMessagesDialog(context),
                      ),
                      _buildManagementCard(
                        context,
                        'Analytics',
                        'View portfolio visits and last activity',
                        Icons.insights,
                        AppTheme.neonCyan,
                        [AppTheme.neonCyan, AppTheme.neonPurple],
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppTheme.glassBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
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
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: AppTheme.bgDarkest,
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
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 10 : 11,
                        color: AppTheme.textSecondary,
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
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 9 : 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.bgDarkest,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.bgDarkest,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.glassBorder),
                boxShadow: AppTheme.neonGlow(
                  color: AppTheme.neonCyan,
                  blurRadius: 20,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.neonLinearGradient(),
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
                              color: AppTheme.bgDarkest,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppTheme.bgDarkest),
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
        ),
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.glassBorder),
                boxShadow: AppTheme.neonGlow(
                  color: AppTheme.neonCyan,
                  blurRadius: 20,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.neonLinearGradient(),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insights, color: AppTheme.bgDarkest),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Analytics',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.bgDarkest,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppTheme.bgDarkest),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _portfolioService.watchVisitStats(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.neonCyan.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to load analytics',
                              style: GoogleFonts.inter(color: AppTheme.neonPink),
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
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppTheme.textGradient.createShader(bounds),
                                child: Text(
                                  total.toStringAsFixed(0),
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Last Visit',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lastVisitText,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Recent Visits',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
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
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme.neonCyan
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      );
                                    }
                                    if (historySnapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Failed to load visit history',
                                          style: GoogleFonts.inter(
                                              color: AppTheme.neonPink),
                                        ),
                                      );
                                    }

                                    final visits =
                                        historySnapshot.data?.docs ?? [];
                                    if (visits.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No visits yet',
                                          style: GoogleFonts.inter(
                                            color: AppTheme.textMuted,
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
                                            color: AppTheme.bgElevated,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppTheme.glassBorder,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.neonCyan
                                                      .withValues(alpha: 0.15),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.public,
                                                  color: AppTheme.neonCyan,
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
                                                      style:
                                                          GoogleFonts.inter(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppTheme
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      visitedAtText,
                                                      style:
                                                          GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: AppTheme
                                                            .textMuted,
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
        ),
      ),
    );
  }

  void _showMessagesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.glassBorder),
                boxShadow: AppTheme.neonGlow(
                  color: AppTheme.neonGreen,
                  blurRadius: 20,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.neonGreen, AppTheme.neonBlue],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mail, color: AppTheme.bgDarkest),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Contact Messages',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.bgDarkest,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppTheme.bgDarkest),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _portfolioService.watchContactMessages(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.neonCyan.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to load messages',
                              style: GoogleFonts.inter(color: AppTheme.neonPink),
                            ),
                          );
                        }

                        final messages = snapshot.data?.docs ?? [];
                        if (messages.isEmpty) {
                          return Center(
                            child: Text(
                              'No messages yet',
                              style: GoogleFonts.inter(
                                color: AppTheme.textMuted,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final msg = messages[index].data();
                            final name = msg['name'] ?? 'Unknown';
                            final email = msg['email'] ?? '';
                            final message = msg['message'] ?? '';
                            final isRead = msg['read'] ?? false;
                            final timestamp = msg['timestamp'];
                            String timeText = '';
                            if (timestamp is Timestamp) {
                              timeText = timestamp.toDate().toString();
                            }

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.bgElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isRead
                                      ? AppTheme.glassBorder
                                      : AppTheme.neonCyan
                                          .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (!isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.neonCyan,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      if (!isRead) const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        timeText,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppTheme.neonCyan,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    message,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!isRead)
                                        TextButton.icon(
                                          onPressed: () {
                                            _portfolioService
                                                .markMessageAsRead(
                                                    messages[index].id);
                                          },
                                          icon: const Icon(Icons.check,
                                              size: 16),
                                          label: Text(
                                            'Mark Read',
                                            style: GoogleFonts.inter(
                                                fontSize: 12),
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppTheme.neonCyan,
                                          ),
                                        ),
                                      TextButton.icon(
                                        onPressed: () {
                                          _portfolioService
                                              .deleteMessage(messages[index].id);
                                        },
                                        icon: const Icon(Icons.delete,
                                            size: 16),
                                        label: Text(
                                          'Delete',
                                          style: GoogleFonts.inter(
                                              fontSize: 12),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppTheme.neonPink,
                                        ),
                                      ),
                                    ],
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
            ),
          ),
        ),
      ),
    );
  }
}
