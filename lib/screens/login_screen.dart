import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        String message = 'An error occurred';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              message = 'No user found with this email';
              break;
            case 'wrong-password':
              message = 'Wrong password provided';
              break;
            case 'invalid-email':
              message = 'The email address is not valid';
              break;
            case 'user-disabled':
              message = 'This user account has been disabled';
              break;
            case 'operation-not-allowed':
              message = 'Email/password accounts are not enabled';
              break;
            default:
              message = 'Error: ${e.message}';
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: GoogleFonts.inter(color: AppTheme.textPrimary),
              ),
              backgroundColor: AppTheme.bgCardLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppTheme.neonPink.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.glassBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.glassBorder),
              boxShadow: AppTheme.neonGlow(
                color: AppTheme.neonCyan,
                blurRadius: 20,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.neonCyan.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.neonCyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      size: 48,
                      color: AppTheme.neonCyan,
                    ),
                  ).animate().fadeIn().scale(),
                  const SizedBox(height: 16),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.textGradient.createShader(bounds),
                    child: Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn().slideY(),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to manage your portfolio',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn()
                      .slideY(delay: 100.ms),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon:
                          const Icon(Icons.email_outlined, color: AppTheme.neonCyan),
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
                        borderSide: BorderSide(
                          color: AppTheme.neonCyan.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: AppTheme.bgCard,
                      labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
                      hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
                    ),
                    style: GoogleFonts.inter(color: AppTheme.textPrimary),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  )
                      .animate()
                      .fadeIn()
                      .slideX(delay: 200.ms),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: AppTheme.neonCyan),
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
                        borderSide: BorderSide(
                          color: AppTheme.neonCyan.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: AppTheme.bgCard,
                      labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
                      hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
                    ),
                    style: GoogleFonts.inter(color: AppTheme.textPrimary),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  )
                      .animate()
                      .fadeIn()
                      .slideX(delay: 300.ms),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isLoading ? null : _login,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: AppTheme.neonLinearGradient(),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppTheme.neonGlow(
                            color: AppTheme.neonCyan,
                            blurRadius: 15,
                          ),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.bgDarkest),
                                  ),
                                )
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.bgDarkest,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn()
                      .slideY(delay: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
