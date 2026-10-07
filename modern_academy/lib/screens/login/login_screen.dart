import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _role = UserRole.student;
  final _idCtrl   = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure   = true;
  String? _error;
  bool _loading   = false;

  final _roles = [
    (UserRole.student, 'Student',  '🎓'),
    (UserRole.teacher, 'Teacher',  '📋'),
    (UserRole.parent,  'Parent',   '👨‍👩‍👧'),
    (UserRole.admin,   'Admin',    '🛡️'),
  ];

  String get _placeholder => switch (_role) {
    UserRole.student => 'e.g. S001',
    UserRole.teacher => 'e.g. T002',
    UserRole.parent  => 'e.g. P001',
    UserRole.admin   => 'e.g. ADM01',
    _ => ''
  };

  String get _hint => switch (_role) {
    UserRole.student => 'pass123',
    UserRole.teacher => 'teach123',
    UserRole.parent  => 'parent123',
    UserRole.admin   => 'admin123',
    _ => ''
  };

  void _login() async {
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 400));
    final ok = context.read<AppProvider>().login(_idCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ShellScreen()));
    } else {
      setState(() { _error = 'Incorrect ID or password.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(children: [
            // Logo
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 3),
                color: AppColors.navy,
              ),
              child: ClipOval(child: Image.asset('assets/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Center(
                    child: Text('MA', style: GoogleFonts.playfairDisplay(
                        fontSize: 26, fontWeight: FontWeight.w900,
                        color: AppColors.gold))))),
            ),
            const SizedBox(height: 14),
            Text('Modern Academy', style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white)),
            const SizedBox(height: 4),
            Text('SCHOOL PORTAL · BELUR', style: GoogleFonts.dmSans(
                fontSize: 10, letterSpacing: 1.5,
                color: AppColors.white.withOpacity(0.45))),
            const SizedBox(height: 28),

            // Login card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sign in', style: GoogleFonts.playfairDisplay(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 16),

                // Role chips
                Wrap(spacing: 8, runSpacing: 8, children: _roles.map((r) {
                  final active = _role == r.$1;
                  return GestureDetector(
                    onTap: () => setState(() { _role = r.$1; _error = null; }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? AppColors.navy : AppColors.cream,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: active ? AppColors.navy : AppColors.border),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(r.$3, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(r.$2, style: GoogleFonts.dmSans(
                            fontSize: 13, fontWeight: FontWeight.w500,
                            color: active ? AppColors.gold : AppColors.muted)),
                      ]),
                    ),
                  );
                }).toList()),
                const SizedBox(height: 18),

                // ID field
                Text('ID / Roll Number', style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w500,
                    letterSpacing: 0.5, color: AppColors.navy)),
                const SizedBox(height: 6),
                TextField(
                  controller: _idCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(hintText: _placeholder,
                      hintStyle: GoogleFonts.dmSans(color: AppColors.muted)),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 14),

                // Password field
                Text('Password', style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w500,
                    letterSpacing: 0.5, color: AppColors.navy)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: _hint,
                    hintStyle: GoogleFonts.dmSans(color: AppColors.muted),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.muted, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onSubmitted: (_) => _login(),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: GoogleFonts.dmSans(
                      color: AppColors.red, fontSize: 13)),
                ],
                const SizedBox(height: 20),

                SizedBox(width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.gold))
                        : const Text('Sign in'),
                  ),
                ),
                const SizedBox(height: 16),

                // Demo hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gold.withOpacity(0.25)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Demo credentials', style: GoogleFonts.dmSans(
                        fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 6),
                    for (final line in [
                      '🎓 Student:  S001 / pass123',
                      '📋 Teacher:  T002 / teach123',
                      '👨‍👩‍👧 Parent:   P001 / parent123',
                      '🛡️  Admin:    ADM01 / admin123',
                    ])
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(line, style: GoogleFonts.dmSans(
                            fontSize: 12, color: const Color(0xFF6B4E1A))),
                      ),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
