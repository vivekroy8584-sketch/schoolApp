import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../data/app_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final u    = prov.currentUser!;
    final firstName = u.name.split(' ').first;

    return ListView(children: [
      // Greeting banner
      Container(
        margin: const EdgeInsets.fromLTRB(16,16,16,4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navy, Color(0xFF162D52)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome back,', style: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.white.withOpacity(0.6))),
            Text(firstName, style: GoogleFonts.playfairDisplay(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.gold)),
            Text(u.roleName + (u.cls != null ? ' · ${u.cls}' : ''),
                style: GoogleFonts.dmSans(
                    fontSize: 12, color: AppColors.white.withOpacity(0.45))),
          ])),
          AvatarCircle(initials: u.initials, size: 50,
              bg: AppColors.gold.withOpacity(0.2), fg: AppColors.gold),
        ]),
      ),

      // Birthday self-banner
      if (u.role == UserRole.student && u.dob != null &&
          AppProvider.bdayStatus(u.dob!).status == 'today')
        Container(
          margin: const EdgeInsets.fromLTRB(16,8,16,4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          ),
          child: Row(children: [
            const Text('🎂', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(child: Text('Happy Birthday, $firstName! 🎉',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy))),
          ]),
        ),

      // Stats row
      Padding(
        padding: const EdgeInsets.fromLTRB(16,12,16,4),
        child: _statsFor(u, prov),
      ),

      PageHeader(tag: 'Latest', title: 'Notice'),
      if (prov.noticesForUser().isNotEmpty) ...[
        SectionCard(child: _noticePreview(prov.noticesForUser().first)),
      ] else
        const EmptyState(emoji: '📢', message: 'No notices right now'),

      PageHeader(tag: 'Pending', title: 'Homework'),
      ...prov.homeworkForUser().take(3).map((h) => SectionCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(width: 4, height: 40,
              decoration: BoxDecoration(
                  color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(h.subject.toUpperCase(), style: GoogleFonts.dmSans(
                fontSize: 10, fontWeight: FontWeight.w600,
                color: AppColors.gold, letterSpacing: 0.8)),
            Text(h.task, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navy,
                    fontWeight: FontWeight.w500)),
            Text('Due: ${h.due}', style: GoogleFonts.dmSans(
                fontSize: 11, color: AppColors.muted)),
          ])),
        ]),
      )),
      const SizedBox(height: 16),
    ]);
  }

  Widget _statsFor(UserModel u, AppProvider prov) {
    final pending = prov.homeworkForUser().where((h) => !prov.hwDone(h.id)).length;
    if (u.role == UserRole.student) {
      final res = results[u.cls] ?? [];
      final avg = res.isEmpty ? 0 :
          (res.fold(0, (s, r) => s + r.marks) / res.length).round();
      return Row(children: [
        Expanded(child: StatCard(label: 'Avg Marks', value: '$avg%', note: 'Unit Test 1')),
        const SizedBox(width: 10),
        Expanded(child: StatCard(label: 'Homework', value: '$pending', note: 'pending')),
      ]);
    }
    if (u.role == UserRole.teacher) {
      final myStudents = prov.allStudents.where((s) => s.cls == u.classTeacher).length;
      return Row(children: [
        Expanded(child: StatCard(label: 'My Class', value: u.classTeacher ?? '—')),
        const SizedBox(width: 10),
        Expanded(child: StatCard(label: 'Students', value: '$myStudents',
            note: 'in ${u.classTeacher}')),
      ]);
    }
    if (u.role == UserRole.parent) {
      final ward = prov.activeWardUser;
      final res  = results[ward?.cls ?? ''] ?? [];
      final avg  = res.isEmpty ? 0 :
          (res.fold(0, (s, r) => s + r.marks) / res.length).round();
      return Row(children: [
        Expanded(child: StatCard(label: 'Ward', value: ward?.name.split(' ').first ?? '—')),
        const SizedBox(width: 10),
        Expanded(child: StatCard(label: 'Avg Marks', value: '$avg%', note: ward?.cls)),
      ]);
    }
    // admin
    return Row(children: [
      Expanded(child: StatCard(label: 'Students', value: '${prov.allStudents.length}')),
      const SizedBox(width: 10),
      Expanded(child: StatCard(label: 'Notices', value: '${prov.notices.length}')),
      const SizedBox(width: 10),
      Expanded(child: StatCard(label: 'Homework', value: '${prov.homework.length}')),
    ]);
  }

  Widget _noticePreview(notice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Text(notice.icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Expanded(child: Text(notice.title, style: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy))),
        TagBadge(label: notice.tag, type: notice.tagType),
      ]),
      const SizedBox(height: 6),
      Text(notice.body, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted)),
    ],
  );
}
