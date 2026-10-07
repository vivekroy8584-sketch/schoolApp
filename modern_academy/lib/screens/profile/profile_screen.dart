import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../data/app_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final u = context.watch<AppProvider>().currentUser!;
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      PageHeader(tag: 'Account', title: 'My Profile'),
      SectionCard(child: Column(children: [
        Row(children: [
          AvatarCircle(initials: u.initials, size: 60),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(u.name, style: GoogleFonts.playfairDisplay(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(u.roleName, style: GoogleFonts.dmSans(
                  fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gold)),
            ),
          ])),
        ]),
        const Divider(height: 24),
        InfoRow(label: 'ID / Roll', value: u.id),
        const Divider(height: 1),
        InfoRow(label: 'Phone', value: u.phone),
        const Divider(height: 1),
        InfoRow(label: 'Email', value: u.email),
        if (u.role == UserRole.student) ...[
          const Divider(height: 1),
          InfoRow(label: 'Class', value: u.cls ?? '—'),
          const Divider(height: 1),
          InfoRow(label: 'Date of Birth',
              value: u.dob != null ? AppProvider.formatDob(u.dob!) : '—'),
        ],
        if (u.role == UserRole.teacher) ...[
          const Divider(height: 1),
          InfoRow(label: 'Subject', value: u.subject ?? '—'),
          const Divider(height: 1),
          InfoRow(label: 'Class Teacher', value: u.classTeacher ?? 'Not assigned'),
        ],
        if (u.role == UserRole.parent) ...[
          const Divider(height: 1),
          InfoRow(
            label: 'Wards',
            value: u.wards.map((w) {
              final s = users[w];
              return '${s?.name ?? w} (${s?.cls ?? ''})';
            }).join(', '),
          ),
        ],
      ])),
    ]);
  }
}
