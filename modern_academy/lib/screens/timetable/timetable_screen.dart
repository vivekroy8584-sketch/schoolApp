import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../data/app_data.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _days = ['Mon','Tue','Wed','Thu','Fri','Sat'];
  late String _day;

  @override
  void initState() {
    super.initState();
    final wd = DateTime.now().weekday;
    _day = wd <= 5 ? _days[wd-1] : 'Mon';
  }

  String _getClass(AppProvider prov) {
    final u = prov.currentUser!;
    if (u.role == UserRole.student)  return u.cls ?? 'X-A';
    if (u.role == UserRole.teacher)  return u.classTeacher ?? 'X-A';
    if (u.role == UserRole.parent)   return prov.activeWardUser?.cls ?? 'X-A';
    return 'X-A';
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final cls  = _getClass(prov);
    final tt   = timetable[cls] ?? timetable['X-A']!;
    final slots= tt[_day] ?? [];

    return Column(children: [
      // Ward selector for parents
      if (prov.currentUser?.role == UserRole.parent &&
          (prov.currentUser?.wards.length ?? 0) > 1)
        _wardBar(prov),

      PageHeader(tag: 'Schedule', title: 'Timetable — $cls'),

      // Day chips
      SizedBox(height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _days.length,
          itemBuilder: (_, i) {
            final d = _days[i];
            final active = d == _day;
            return GestureDetector(
              onTap: () => setState(() => _day = d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: active ? AppColors.navy : AppColors.border),
                ),
                child: Text(d, style: GoogleFonts.dmSans(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: active ? AppColors.gold : AppColors.muted)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),

      Expanded(child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16,0,16,24),
        itemCount: slots.length,
        itemBuilder: (_, i) {
          final s = slots[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: s.isBreak ? AppColors.cream : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              SizedBox(width: 72, child: Text(s.time,
                  style: GoogleFonts.dmSans(
                      fontSize: 11, color: AppColors.muted))),
              const SizedBox(width: 10),
              Container(width: 3, height: 24,
                  decoration: BoxDecoration(
                    color: s.isBreak ? AppColors.border : AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  )),
              const SizedBox(width: 10),
              Text(s.subject, style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: s.isBreak ? FontWeight.w400 : FontWeight.w500,
                  color: s.isBreak ? AppColors.muted : AppColors.navy,
                  fontStyle: s.isBreak ? FontStyle.italic : FontStyle.normal)),
            ]),
          );
        },
      )),
    ]);
  }

  Widget _wardBar(AppProvider prov) => Container(
    color: AppColors.white,
    padding: const EdgeInsets.fromLTRB(16,8,16,8),
    child: DropdownButtonFormField<String>(
      value: prov.activeWard,
      decoration: const InputDecoration(
          labelText: 'Viewing ward', contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      items: prov.currentUser!.wards.map((w) {
        final s = users[w];
        return DropdownMenuItem(value: w,
            child: Text('${s?.name ?? w} (${s?.cls ?? ''})'));
      }).toList(),
      onChanged: (v) { if (v != null) prov.setActiveWard(v); },
    ),
  );
}
