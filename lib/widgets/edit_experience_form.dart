import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/experience_section.dart';

class EditExperienceForm extends StatefulWidget {
  const EditExperienceForm({super.key});

  @override
  State<EditExperienceForm> createState() => _EditExperienceFormState();
}

class _EditExperienceFormState extends State<EditExperienceForm> {
  final PortfolioService _portfolioService = PortfolioService();
  List<ExperienceItem> _experiences = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExperienceData();
  }

  Future<void> _loadExperienceData() async {
    try {
      final data = await _portfolioService.getExperienceData();
      setState(() {
        _experiences = data.map((e) => ExperienceItem.fromMap(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _darkInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, color: AppTheme.neonCyan, size: 20),
      filled: true,
      fillColor: AppTheme.bgCard,
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
        borderSide: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
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

  void _showAddEditDialog({ExperienceItem? item, int? index}) {
    final isEdit = item != null;
    final roleController = TextEditingController(text: item?.role ?? '');
    final companyController = TextEditingController(text: item?.company ?? '');
    final periodController = TextEditingController(text: item?.period ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final achievementsController = TextEditingController(
      text: item?.achievements.join('\n') ?? '',
    );
    IconData selectedIcon = item?.icon ?? Icons.work;
    Color selectedColor = item?.color ?? AppTheme.neonCyan;

    final iconOptions = [
      Icons.code, Icons.phone_android, Icons.school, Icons.work,
      Icons.build, Icons.rocket_launch, Icons.star, Icons.computer,
      Icons.psychology, Icons.group,
    ];

    final colorOptions = [
      AppTheme.neonCyan, AppTheme.neonPurple, AppTheme.neonBlue,
      AppTheme.neonGreen, AppTheme.neonPink,
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isEdit ? 'Edit Experience' : 'Add Experience',
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: roleController,
                  style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
                  decoration: _darkInputDecoration('Role / Position', Icons.person),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: companyController,
                  style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
                  decoration: _darkInputDecoration('Company', Icons.business),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: periodController,
                  style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
                  decoration: _darkInputDecoration('Period (e.g. 2023 — Present)', Icons.date_range),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
                  maxLines: 3,
                  decoration: _darkInputDecoration('Description', Icons.description),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: achievementsController,
                  style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
                  maxLines: 4,
                  decoration: _darkInputDecoration(
                    'Achievements (one per line)',
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(height: 16),
                // Icon picker
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Icon',
                      style: GoogleFonts.inter(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: iconOptions.map((icon) {
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = icon),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.neonCyan.withValues(alpha: 0.2)
                              : AppTheme.bgCardLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.neonCyan
                                : AppTheme.glassBorder,
                          ),
                        ),
                        child: Icon(icon,
                            color: isSelected
                                ? AppTheme.neonCyan
                                : AppTheme.textSecondary,
                            size: 20),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Color picker
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Color',
                      style: GoogleFonts.inter(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: colorOptions.map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neonCyan,
                foregroundColor: AppTheme.bgDarkest,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                if (roleController.text.trim().isEmpty) return;
                final achievements = achievementsController.text
                    .split('\n')
                    .where((e) => e.trim().isNotEmpty)
                    .map((e) => e.trim())
                    .toList();

                final newItem = ExperienceItem(
                  id: item?.id ?? '',
                  role: roleController.text.trim(),
                  company: companyController.text.trim(),
                  period: periodController.text.trim(),
                  description: descriptionController.text.trim(),
                  achievements: achievements,
                  icon: selectedIcon,
                  color: selectedColor,
                );

                try {
                  if (isEdit) {
                    await _portfolioService.updateExperienceItem(
                        newItem.id, newItem.toMap());
                  } else {
                    await _portfolioService.addExperienceItem(newItem.toMap());
                  }
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _loadExperienceData();
                  _showSuccessSnackBar(
                      isEdit ? 'Experience updated' : 'Experience added');
                } catch (e) {
                  _showErrorSnackBar('Error: $e');
                }
              },
              child: Text(isEdit ? 'Update' : 'Add',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteExperience(int index) async {
    final item = _experiences[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Experience',
            style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        content: Text('Are you sure you want to delete this experience item?',
            style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );

    if (confirmed == true && item.id.isNotEmpty) {
      try {
        await _portfolioService.deleteExperienceItem(item.id);
        _loadExperienceData();
        _showSuccessSnackBar('Experience deleted');
      } catch (e) {
        _showErrorSnackBar('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
        ),
      );
    }

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Experience Items',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: Text('Add', style: GoogleFonts.inter(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonCyan,
                  foregroundColor: AppTheme.bgDarkest,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_experiences.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No experience items yet. Click "Add" to create one.',
                  style: GoogleFonts.inter(
                      color: AppTheme.textMuted, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ..._experiences.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.bgCardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: exp.color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: exp.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(exp.icon, color: exp.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.role,
                            style: GoogleFonts.poppins(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${exp.company} • ${exp.period}',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.neonCyan, size: 18),
                      onPressed: () =>
                          _showAddEditDialog(item: exp, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppTheme.neonPink, size: 18),
                      onPressed: () => _deleteExperience(index),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
