import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/services/portfolio_service.dart';

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
    SkillCategory(
      title: 'Programming Languages',
      skills: [],
      icon: Icons.code,
      color: Colors.blue,
    ),
    SkillCategory(
      title: 'Flutter Development',
      skills: [],
      icon: Icons.flutter_dash,
      color: Colors.indigo,
    ),
    SkillCategory(
      title: 'Mobile Development',
      skills: [],
      icon: Icons.phone_android,
      color: Colors.green,
    ),
    SkillCategory(
      title: 'Architecture Patterns',
      skills: [],
      icon: Icons.architecture,
      color: Colors.orange,
    ),
    SkillCategory(
      title: 'Version Control',
      skills: [],
      icon: Icons.merge_type,
      color: Colors.red,
    ),
    SkillCategory(
      title: 'UI/UX Design Tools',
      skills: [],
      icon: Icons.design_services,
      color: Colors.pink,
    ),
    SkillCategory(
      title: 'IDEs & Tools',
      skills: [],
      icon: Icons.build,
      color: Colors.amber,
    ),
    SkillCategory(
      title: 'Soft Skills',
      skills: [],
      icon: Icons.people,
      color: Colors.cyan,
    ),
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
      if (!mounted) {
        return;
      }
      if (data != null && data['categories'] != null) {
        final List<dynamic> categories = data['categories'];
        for (int i = 0;
            i < categories.length && i < _skillCategories.length;
            i++) {
          _skillCategories[i].skills =
              List<String>.from(categories[i]['skills'] ?? []);
        }
        setState(() {});
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showErrorSnackBar('Error loading skills data');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

      if (!mounted) {
        return;
      }
      _showSuccessSnackBar('Skills updated successfully');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showErrorSnackBar('Error updating skills: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            color: Colors.black87,
          ),
        ).animate().fadeIn().slideX(),

        const SizedBox(height: 8),

        Text(
          'Organize your skills by categories. Click on any category to manage its skills.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 100)),

        const SizedBox(height: 20),

        Expanded(
          child: ListView.builder(
            itemCount: _skillCategories.length,
            itemBuilder: (context, index) {
              final category = _skillCategories[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: category.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                    ),
                  ),
                  title: Text(
                    category.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${category.skills.length} skill${category.skills.length != 1 ? 's' : ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _addSkill(index),
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Skill',
                      ),
                      const Icon(Icons.expand_more),
                    ],
                  ),
                  children: [
                    if (category.skills.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No skills added yet. Click the + button to add skills.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
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
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      _editSkill(index, skillIndex),
                                  icon: const Icon(Icons.edit, size: 20),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _deleteSkill(index, skillIndex),
                                  icon: const Icon(Icons.delete,
                                      size: 20, color: Colors.red),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
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
            onPressed: _isLoading ? null : _saveSkills,
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
                    'Save All Skills',
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

class _AddSkillDialog extends StatefulWidget {
  final String? initialSkill;
  final Function(String) onAdd;

  const _AddSkillDialog({
    this.initialSkill,
    required this.onAdd,
  });

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialSkill != null ? 'Edit Skill' : 'Add New Skill',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter skill name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
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
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                    ),
                  ),
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
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    widget.initialSkill != null ? 'Update' : 'Add',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
