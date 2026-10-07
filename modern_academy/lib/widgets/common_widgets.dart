import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Section header (gold tag + navy title) ────────────────────────────────
class PageHeader extends StatelessWidget {
  final String tag;
  final String title;
  final Widget? action;
  const PageHeader({super.key, required this.tag, required this.title, this.action});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tag.toUpperCase(),
          style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600,
              letterSpacing: 1.2, color: AppColors.gold)),
      const SizedBox(height: 4),
      Row(children: [
        Expanded(child: Text(title,
            style: GoogleFonts.playfairDisplay(fontSize: 22,
                fontWeight: FontWeight.w700, color: AppColors.navy))),
        if (action != null) action!,
      ]),
      const SizedBox(height: 12),
    ]),
  );
}

// ── Avatar circle ─────────────────────────────────────────────────────────
class AvatarCircle extends StatelessWidget {
  final String initials;
  final double size;
  final Color bg;
  final Color fg;
  const AvatarCircle({super.key, required this.initials,
    this.size = 44, this.bg = AppColors.navy, this.fg = AppColors.gold});

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    child: Center(child: Text(initials,
        style: GoogleFonts.playfairDisplay(
            fontSize: size * 0.38, fontWeight: FontWeight.w700, color: fg))),
  );
}

// ── Coloured badge pill ───────────────────────────────────────────────────
class TagBadge extends StatelessWidget {
  final String label;
  final String type; // urgent | info | event
  const TagBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'urgent': (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
      'info':   (const Color(0xFFDBEAFE), const Color(0xFF1E40AF)),
      'event':  (const Color(0xFFF3E8FF), const Color(0xFF6B21A8)),
    };
    final pair = colors[type] ?? colors['info']!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: pair.$1, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: GoogleFonts.dmSans(
          fontSize: 10, fontWeight: FontWeight.w600, color: pair.$2)),
    );
  }
}

// ── Grade badge ───────────────────────────────────────────────────────────
class GradeBadge extends StatelessWidget {
  final String grade;
  const GradeBadge({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'A': (const Color(0xFFDCFCE7), const Color(0xFF166534)),
      'B': (const Color(0xFFDBEAFE), const Color(0xFF1E40AF)),
      'C': (const Color(0xFFFEF9C3), const Color(0xFF854D0E)),
      'D': (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
    };
    final pair = colors[grade] ?? colors['D']!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: pair.$1, borderRadius: BorderRadius.circular(20)),
      child: Text(grade, style: GoogleFonts.dmSans(
          fontSize: 11, fontWeight: FontWeight.w700, color: pair.$2)),
    );
  }
}

// ── Stat card ────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? note;
  const StatCard({super.key, required this.label, required this.value, this.note});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w500,
              letterSpacing: 0.8, color: AppColors.muted)),
      const SizedBox(height: 6),
      Text(value, style: GoogleFonts.playfairDisplay(
          fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.navy)),
      if (note != null) ...[
        const SizedBox(height: 2),
        Text(note!, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
      ],
    ]),
  );
}

// ── Section card wrapper ──────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const SectionCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    padding: padding ?? const EdgeInsets.all(16),
    child: child,
  );
}

// ── Empty state ───────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji;
  final String message;
  const EmptyState({super.key, required this.emoji, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text(message, style: GoogleFonts.dmSans(color: AppColors.muted, fontSize: 14),
            textAlign: TextAlign.center),
      ])),
  );
}

// ── Divider row ───────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w500,
              letterSpacing: 0.8, color: AppColors.muted)),
      const SizedBox(height: 3),
      Text(value, style: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.navy)),
    ]),
  );
}
