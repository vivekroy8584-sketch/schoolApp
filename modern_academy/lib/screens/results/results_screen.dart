import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../data/app_data.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Color _barColor(double pct) {
    if (pct >= 75) return AppColors.green;
    if (pct >= 60) return const Color(0xFF2563EB);
    if (pct >= 45) return const Color(0xFFD97706);
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final u    = prov.currentUser!;
    String cls = u.cls ?? 'X-A';
    if (u.role == UserRole.parent) cls = prov.activeWardUser?.cls ?? 'X-A';
    final res  = results[cls] ?? [];
    final total= res.fold(0, (s, r) => s + r.marks);
    final avg  = res.isEmpty ? 0 : (total / res.length).round();
    final grade= res.isEmpty ? '—' : ResultEntry(
        subject:'', marks: avg, max: 100).grade;

    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      if (u.role == UserRole.parent && u.wards.length > 1)
        Padding(
          padding: const EdgeInsets.fromLTRB(16,12,16,0),
          child: DropdownButtonFormField<String>(
            value: prov.activeWard,
            decoration: const InputDecoration(labelText: 'Viewing ward',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            items: u.wards.map((w) {
              final s = users[w];
              return DropdownMenuItem(value: w,
                  child: Text('${s?.name ?? w} (${s?.cls ?? ''})'));
            }).toList(),
            onChanged: (v) { if (v != null) prov.setActiveWard(v); },
          ),
        ),

      PageHeader(tag: 'Academic', title: 'Results & Marks'),
      SectionCard(child: Column(children: [
        Row(children: [
          Expanded(child: Text('Unit Test 1 — 2026 · $cls',
              style: GoogleFonts.playfairDisplay(fontSize: 14,
                  fontWeight: FontWeight.w700, color: AppColors.navy))),
        ]),
        const SizedBox(height: 16),
        ...res.map((r) {
          final pct = r.percentage;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(r.subject,
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navy,
                        fontWeight: FontWeight.w500))),
                Text('${r.marks}/${r.max}',
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navy,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                GradeBadge(grade: r.grade),
              ]),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct / 100,
                  minHeight: 7,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(_barColor(pct)),
                ),
              ),
            ]),
          );
        }),

        const Divider(height: 24),
        Row(children: [
          Expanded(child: _SumBox(label: 'Total', value: '$total')),
          const SizedBox(width: 8),
          Expanded(child: _SumBox(label: 'Average', value: '$avg%')),
          const SizedBox(width: 8),
          Expanded(child: _SumBox(label: 'Grade', value: grade)),
        ]),
      ])),
    ]);
  }
}

class _SumBox extends StatelessWidget {
  final String label;
  final String value;
  const _SumBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(children: [
      Text(value, style: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
      const SizedBox(height: 2),
      Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
    ]),
  );
}
