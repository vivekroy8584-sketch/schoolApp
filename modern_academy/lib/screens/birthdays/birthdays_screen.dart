import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class BirthdaysScreen extends StatelessWidget {
  const BirthdaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final u    = prov.currentUser!;

    // Students only see their own birthday
    if (u.role == UserRole.student) return _StudentBdayView(user: u);

    // Teachers see their class, parents their wards, admin sees all
    List<UserModel> list = prov.allStudents;
    if (u.role == UserRole.teacher && u.classTeacher != null)
      list = list.where((s) => s.cls == u.classTeacher).toList();
    if (u.role == UserRole.parent)
      list = u.wards.map((w) => prov.allStudents
          .firstWhere((s) => s.id == w, orElse: () => u)).toList();

    list.sort((a, b) =>
        AppProvider.bdayStatus(a.dob!).days
            .compareTo(AppProvider.bdayStatus(b.dob!).days));

    final todayList = list.where((s) =>
        AppProvider.bdayStatus(s.dob!).status == 'today').toList();

    return Column(children: [
      PageHeader(tag: 'Celebrations', title: 'Birthdays'),
      if (todayList.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16,0,16,12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            const Text('🎂', style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(todayList.map((s) => s.name).join(' & '),
                  style: GoogleFonts.playfairDisplay(fontSize: 14,
                      fontWeight: FontWeight.w700, color: AppColors.white)),
              Text('${todayList.length > 1 ? "have" : "has"} a birthday today!',
                  style: GoogleFonts.dmSans(fontSize: 12,
                      color: AppColors.white.withOpacity(0.55))),
            ])),
          ]),
        ),

      Expanded(child: list.isEmpty
        ? const EmptyState(emoji: '🎈', message: 'No students found')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16,0,16,24),
            itemCount: list.length,
            itemBuilder: (_, i) => _BdayCard(student: list[i]),
          )),
    ]);
  }
}

class _StudentBdayView extends StatelessWidget {
  final UserModel user;
  const _StudentBdayView({required this.user});

  @override
  Widget build(BuildContext context) {
    final bs = AppProvider.bdayStatus(user.dob!);
    final isToday = bs.status == 'today';
    return ListView(padding: const EdgeInsets.fromLTRB(16,24,16,24), children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Text(isToday ? '🎂' : '🎈',
              style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(isToday ? 'Happy Birthday, ${user.name.split(" ").first}!'
              : 'Your Birthday',
              style: GoogleFonts.playfairDisplay(fontSize: 20,
                  fontWeight: FontWeight.w700, color: AppColors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(isToday
              ? 'Modern Academy wishes you a wonderful day filled with joy, success and wonderful memories! 🎉'
              : 'Your birthday is ${bs.label}. We\'ll be celebrating you soon!',
              style: GoogleFonts.dmSans(fontSize: 13,
                  color: AppColors.white.withOpacity(0.65), height: 1.6),
              textAlign: TextAlign.center),
          if (isToday) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showWish(context, user.name),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold, foregroundColor: AppColors.navy,
                  minimumSize: const Size(0, 44)),
              child: const Text('See My Birthday Wish 🎁'),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          const Text('🔒', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('Birthday wishes are private',
                style: GoogleFonts.playfairDisplay(fontSize: 14,
                    fontWeight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 4),
            Text('Only you can see your own birthday page. '
                'Your special day stays personal.',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
          ])),
        ]),
      ),
    ]);
  }

  void _showWish(BuildContext ctx, String name) => showDialog(
    context: ctx,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(24), child:
        Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎂', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text('Happy Birthday, ${name.split(" ").first}!',
              style: GoogleFonts.playfairDisplay(fontSize: 20,
                  fontWeight: FontWeight.w700, color: AppColors.navy),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Wishing you a fantastic birthday! May this special day bring joy, '
              'laughter and wonderful memories. From all of us at Modern Academy, Belur! 🎉',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted, height: 1.6),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
        ]),
      ),
    ),
  );
}

class _BdayCard extends StatelessWidget {
  final UserModel student;
  const _BdayCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final bs = AppProvider.bdayStatus(student.dob!);
    final isToday = bs.status == 'today';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
          ),
          child: Row(children: [
            AvatarCircle(initials: student.initials, size: 38,
                bg: AppColors.gold.withOpacity(0.2), fg: AppColors.goldLight),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(student.name, style: GoogleFonts.playfairDisplay(
                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.white)),
              Text('${student.cls} · ${student.id}',
                  style: GoogleFonts.dmSans(fontSize: 11,
                      color: AppColors.white.withOpacity(0.5))),
            ])),
          ]),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(14,10,14,10),
          child: Row(children: [
            Text('🎂 ${AppProvider.formatDob(student.dob!)}',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isToday
                    ? AppColors.gold.withOpacity(0.15)
                    : AppColors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(bs.label, style: GoogleFonts.dmSans(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: isToday ? const Color(0xFF92400E) : AppColors.green)),
            ),
          ]),
        ),
        if (isToday)
          Padding(padding: const EdgeInsets.fromLTRB(14,0,14,12),
            child: SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _sendWish(context, student.name),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0,36),
                    backgroundColor: AppColors.navy, foregroundColor: AppColors.gold,
                    textStyle: GoogleFonts.dmSans(fontSize: 13)),
                child: const Text('Send Wish 🎉'),
              ),
            ),
          ),
      ]),
    );
  }

  void _sendWish(BuildContext ctx, String name) => showDialog(
    context: ctx,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(24), child:
        Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          Text('Happy Birthday, ${name.split(" ").first}!',
              style: GoogleFonts.playfairDisplay(fontSize: 18,
                  fontWeight: FontWeight.w700, color: AppColors.navy),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('May your birthday be filled with joy and wonderful moments! '
              'Best wishes from Modern Academy, Belur! 🎂',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted, height: 1.6),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
        ]),
      ),
    ),
  );
}
