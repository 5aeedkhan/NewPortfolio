import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';

class SkillCategory {
  String title;
  List<String> skills;
  IconData icon;
  Color color;

  SkillCategory({
    required this.title,
    required this.skills,
    required this.icon,
    required this.color,
  });
}

class EditSkillsForm extends StatefulWidget {
  const EditSkillsForm({super.key});

  @override
  State<EditSkillsForm> createState() => _EditSkillsFormState();
}

class _EditSkillsFormState extends State<EditSkillsForm> {
  final PortfolioService _portfolioService = PortfolioService();
  bool _isLoading = false;

  final List<SkillCategory> _skillCategories = [
    SkillCategory(title: 'Programming Languages', skills: [], icon: Icons.code, color: AppTheme.neonCyan),
    SkillCategory(title: 'Flutter Development', skills: [], icon: Icons.flutter_dash, color: AppTheme.neonBlue),
    SkillCategory(title: 'Mobile Development', skills: [], icon: Icons.phone_android, color: AppTheme.neonGreen),
    SkillCategory(title: 'Architecture Patterns', skills: [], icon: Icons.architecture, color: AppTheme.neonPurple),
    SkillCategory(title: 'Version Control', skills: [], icon: Icons.merge_type, color: AppTheme.neonPink),
    SkillCategory(title: 'UI/UX Design Tools', skills: [], icon: Icons.design_services, color: AppTheme.neonPink),
    SkillCategory(title: 'IDEs & Tools', skills: [], icon: Icons.build, color: AppTheme.neonCyan),
    SkillCategory(title: 'Soft Skills', skills: [], icon: Icons.people, color: AppTheme.neonGreen),
  ];

  @override
  void initState() {
    super.initState();
    _loadSkillsData();
  }

  Future<void> _loadSkillsData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _portfolioService.getSkillsData();
      if (!mounted) return;
      if (data != null && data['categories'] != null) {
        final List<dynamic> categories = data['categories'];
        for (int i = 0; i < categories.length && i < _skillCategories.length; i++) {
          _skillCategories[i].skills = List<String>.from(categories[i]['skills'] ?? []);
        }
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error loading skills data');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSkills() async {
    setState(() => _isLoading = true);
    try {
      final categoriesData = _skillCategories
          .map((category) => {
                'title': category.title,
                'skills': category.skills,
                'icon': category.icon.codePoint.toString(),
                'color': category.color.toARGB32().toString(),
              })
          .toList();

      await _portfolioService.updateSkillsData({
        'categories': categoriesData,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      if (!mounted) return;
      _showSuccessSnackBar('Skills updated successfully');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Error updating skills: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: AppTheme.textPrimary)),
        backgroundColor: AppTheme.bgCardLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: AppTheme.textPrimary)),
        backgroundColor: AppTheme.bgCardLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppTheme.neonPink.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  void _addSkill(int categoryIndex) {
    showDialog(
      context: context,
      builder: (context) => _AddSkillDialog(
        onAdd: (skill) {
          setState(() {
            _skillCategories[categoryIndex].skills.add(skill);
          });
        },
      ),
    );
  }

  void _editSkill(int categoryIndex, int skillIndex) {
    showDialog(
      context: context,
      builder: (context) => _AddSkillDialog(
        initialSkill: _skillCategories[categoryIndex].skills[skillIndex],
        onAdd: (skill) {
          setState(() {
            _skillCategories[categoryIndex].skills[skillIndex] = skill;
          });
        },
      ),
    );
  }

  void _deleteSkill(int categoryIndex, int skillIndex) {
    setState(() {
      _skillCategories[categoryIndex].skills.removeAt(skillIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Skills',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Organize your skills by categories. Click on any category to manage its skills.',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _skillCategories.length,
            itemBuilder: (context, index) {
              final category = _skillCategories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: category.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(category.icon, color: category.color),
                  ),
                  title: Text(
                    category.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${category.skills.length} skill${category.skills.length != 1 ? 's' : ''}',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  iconColor: AppTheme.neonCyan,
                  collapsedIconColor: AppTheme.textSecondary,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _addSkill(index),
                        icon: const Icon(Icons.add, color: AppTheme.neonCyan),
                        tooltip: 'Add Skill',
                      ),
                    ],
                  ),
                  children: [
                    if (category.skills.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No skills added yet. Click the + button to add skills.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: category.skills.length,
                        itemBuilder: (context, skillIndex) {
                          final skill = category.skills[skillIndex];
                          return ListTile(
                            title: Text(
                              skill,
                              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _editSkill(index, skillIndex),
                                  icon: const Icon(Icons.edit, size: 18, color: AppTheme.neonCyan),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  onPressed: () => _deleteSkill(index, skillIndex),
                                  icon: const Icon(Icons.delete, size: 18, color: AppTheme.neonPink),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveSkills,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppTheme.neonCyan,
              foregroundColor: AppTheme.bgDarkest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? CircularProgressIndicator(color: AppTheme.bgDarkest)
                : Text(
                    'Save All Skills',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }
}

class _AddSkillDialog extends StatefulWidget {
  final String? initialSkill;
  final Function(String) onAdd;

  const _AddSkillDialog({this.initialSkill, required this.onAdd});

  @override
  State<_AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<_AddSkillDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSkill != null) {
      _controller.text = widget.initialSkill!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.glassBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.initialSkill != null ? 'Edit Skill' : 'Add New Skill',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controller,
                  style: GoogleFonts.inter(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter skill name',
                    hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.6), width: 1.5),
                    ),
                    filled: true,
                    fillColor: AppTheme.bgElevated,
                  ),
                  autofocus: true,
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      widget.onAdd(value.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: GoogleFonts.inter(color: AppTheme.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          widget.onAdd(_controller.text.trim());
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonCyan,
                        foregroundColor: AppTheme.bgDarkest,
                      ),
                      child: Text(
                        widget.initialSkill != null ? 'Update' : 'Add',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
