import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/services/portfolio_service.dart';
import 'package:portfolio/theme/app_theme.dart';

class EditHeroStatsForm extends StatefulWidget {
  const EditHeroStatsForm({super.key});

  @override
  State<EditHeroStatsForm> createState() => _EditHeroStatsFormState();
}

class _EditHeroStatsFormState extends State<EditHeroStatsForm> {
  final PortfolioService _portfolioService = PortfolioService();
  List<Map<String, dynamic>> _stats = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _portfolioService.getHeroStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _darkInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
      filled: true,
      fillColor: AppTheme.bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                'Hero Stats',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _stats.add({'value': 0, 'suffix': '+', 'label': ''});
                  });
                },
                icon: const Icon(Icons.add, size: 18),
                label: Text('Add Stat', style: GoogleFonts.inter(fontSize: 13)),
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
          ..._stats.asMap().entries.map((entry) {
            final index = entry.key;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.bgCardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.glassBorder),
              ),
              child: Row(
                children: [
                  // Value
                  SizedBox(
                    width: 60,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                          color: AppTheme.textPrimary, fontSize: 13),
                      decoration: _darkInputDecoration('Value'),
                      controller: TextEditingController(
                        text: _stats[index]['value'].toString(),
                      ),
                      onChanged: (val) {
                        _stats[index]['value'] = int.tryParse(val) ?? 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Suffix
                  SizedBox(
                    width: 50,
                    child: TextField(
                      style: GoogleFonts.inter(
                          color: AppTheme.textPrimary, fontSize: 13),
                      decoration: _darkInputDecoration('+'),
                      controller: TextEditingController(
                        text: _stats[index]['suffix'] ?? '',
                      ),
                      onChanged: (val) {
                        _stats[index]['suffix'] = val;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Label
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(
                          color: AppTheme.textPrimary, fontSize: 13),
                      decoration: _darkInputDecoration('Label (e.g. Projects Done)'),
                      controller: TextEditingController(
                        text: _stats[index]['label'] ?? '',
                      ),
                      onChanged: (val) {
                        _stats[index]['label'] = val;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.neonPink, size: 18),
                    onPressed: () {
                      setState(() {
                        _stats.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neonCyan,
                foregroundColor: AppTheme.bgDarkest,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isSaving
                  ? null
                  : () async {
                      setState(() => _isSaving = true);
                      try {
                        await _portfolioService.updateHeroStats(_stats);
                        _showSuccessSnackBar('Hero stats saved successfully');
                        if (!mounted) return;
                        Navigator.pop(context);
                      } catch (e) {
                        _showErrorSnackBar('Error: $e');
                      } finally {
                        if (mounted) setState(() => _isSaving = false);
                      }
                    },
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.bgDarkest),
                      ),
                    )
                  : Text('Save Stats',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
