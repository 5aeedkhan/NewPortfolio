import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: isMobile
            ? 16
            : isTablet
                ? 24
                : 32,
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
          Text(
            'Skills & Competencies',
            style: GoogleFonts.poppins(
              fontSize: isMobile
                  ? 22
                  : isTablet
                      ? 26
                      : 30,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn().slideX(),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile
                ? 1
                : isTablet
                    ? 2
                    : 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: isMobile
                ? 2.2
                : isTablet
                    ? 2.5
                    : 2.8,
            children: const [
              SkillCard(
                icon: Icons.code,
                title: 'Programming Languages',
                skills: ['Dart', 'JavaScript'],
                color: Colors.blue,
                index: 0,
              ),
              SkillCard(
                icon: Icons.flutter_dash,
                title: 'Flutter Development',
                skills: [
                  'UI/UX Implementation',
                  'Custom Widgets',
                  'State Management (Provider, Riverpod)',
                  'Animations (Implicit, Explicit, flutter_animate)',
                  'REST APIs Integration',
                  'Firebase (Auth, Firestore, Storage, Cloud Messaging)',
                  'Image Uploading (ImgBB API)',
                ],
                color: Colors.indigo,
                index: 1,
              ),
              SkillCard(
                icon: Icons.phone_android,
                title: 'Mobile Development',
                skills: [
                  'Cross-Platform Apps (iOS & Android)',
                  'Native Android Understanding',
                ],
                color: Colors.green,
                index: 2,
              ),
              SkillCard(
                icon: Icons.architecture,
                title: 'Architecture Patterns',
                skills: ['MVVM (Model-View-ViewModel)'],
                color: Colors.orange,
                index: 3,
              ),
              SkillCard(
                icon: Icons.merge_type,
                title: 'Version Control',
                skills: ['Git', 'GitHub'],
                color: Colors.red,
                index: 4,
              ),
              SkillCard(
                icon: Icons.design_services,
                title: 'UI/UX Design Tools',
                skills: ['Figma', 'Adobe XD', 'Canva'],
                color: Colors.pink,
                index: 5,
              ),
              SkillCard(
                icon: Icons.build,
                title: 'IDEs & Tools',
                skills: ['Android Studio', 'Visual Studio Code'],
                color: Colors.amber,
                index: 6,
              ),
              SkillCard(
                icon: Icons.people,
                title: 'Soft Skills',
                skills: [
                  'Strong Communication & Presentation',
                  'Time Management & Organization',
                  'Team Collaboration & Leadership',
                  'Problem Solving & Critical Thinking',
                ],
                color: Colors.cyan,
                index: 7,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SkillCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> skills;
  final Color color;
  final int index;

  const SkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.skills,
    required this.color,
    required this.index,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool isHovered = false;

  void _showSkillsDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: isMobile
              ? double.infinity
              : isTablet
                  ? 500
                  : 600,
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: isMobile ? 24 : 28,
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 16),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile
                            ? 20
                            : isTablet
                                ? 22
                                : 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 20 : 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.skills.map((skill) => Padding(
                      padding: EdgeInsets.only(bottom: isMobile ? 8 : 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_right,
                            size: isMobile ? 16 : 20,
                            color: widget.color,
                          ),
                          SizedBox(width: isMobile ? 6 : 8),
                          Expanded(
                            child: Text(
                              skill,
                              style: GoogleFonts.poppins(
                                fontSize: isMobile
                                    ? 14
                                    : isTablet
                                        ? 15
                                        : 16,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => _showSkillsDialog(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(isHovered ? 0.05 : 0)
            ..rotateY(isHovered ? 0.05 : 0),
          child: Card(
            elevation: isHovered ? 8 : 4,
            shadowColor: widget.color.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isHovered ? widget.color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 6 : 8),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: isMobile ? 20 : 24,
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: isMobile
                                ? 14
                                : isTablet
                                    ? 16
                                    : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: isMobile ? 14 : 16,
                        color: widget.color.withOpacity(0.7),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.skills.length > 5 ? 5 : widget.skills.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: isMobile ? 3 : 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.arrow_right,
                                size: isMobile ? 12 : 14,
                                color: widget.color,
                              ),
                              SizedBox(width: isMobile ? 2 : 3),
                              Expanded(
                                child: Text(
                                  widget.skills[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile
                                        ? 11
                                        : isTablet
                                            ? 12
                                            : 13,
                                    color: Colors.grey[800],
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.skills.length > 5)
                    Padding(
                      padding: EdgeInsets.only(top: isMobile ? 4 : 6),
                      child: Text(
                        'Click to see all ${widget.skills.length} skills',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 10 : 11,
                          color: widget.color,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 * widget.index),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutQuad,
        );
  }
}
