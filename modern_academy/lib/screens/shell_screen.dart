import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'home/dashboard_screen.dart';
import 'profile/profile_screen.dart';
import 'timetable/timetable_screen.dart';
import 'notices/notices_screen.dart';
import 'homework/homework_screen.dart';
import 'results/results_screen.dart';
import 'birthdays/birthdays_screen.dart';
import 'admin/admin_screen.dart';
import 'login/login_screen.dart';

class _NavGroup {
  final String id;
  final IconData icon;
  final String label;
  final List<_SubPage> subs;
  const _NavGroup(this.id, this.icon, this.label, this.subs);
}

class _SubPage {
  final String label;
  final Widget screen;
  const _SubPage(this.label, this.screen);
}

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});
  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _groupIdx = 0;
  int _subIdx   = 0;

  List<_NavGroup> _groups(UserRole role) => switch (role) {
    UserRole.student => [
      _NavGroup('home', Icons.home_rounded, 'Home', [
        const _SubPage('Overview',   DashboardScreen()),
        const _SubPage('My Profile', ProfileScreen()),
      ]),
      _NavGroup('info', Icons.menu_book_rounded, 'Info', [
        const _SubPage('Timetable', TimetableScreen()),
        const _SubPage('Results',   ResultsScreen()),
      ]),
      _NavGroup('school', Icons.school_rounded, 'School', [
        const _SubPage('Notices',  NoticesScreen()),
        const _SubPage('Homework', HomeworkScreen()),
      ]),
      _NavGroup('more', Icons.cake_rounded, 'Birthday', [
        const _SubPage('My Birthday', BirthdaysScreen()),
      ]),
    ],
    UserRole.teacher => [
      _NavGroup('home', Icons.home_rounded, 'Home', [
        const _SubPage('Overview',   DashboardScreen()),
        const _SubPage('My Profile', ProfileScreen()),
      ]),
      _NavGroup('info', Icons.menu_book_rounded, 'Info', [
        const _SubPage('Timetable', TimetableScreen()),
      ]),
      _NavGroup('manage', Icons.edit_note_rounded, 'Manage', [
        const _SubPage('Notices',  NoticesScreen()),
        const _SubPage('Homework', HomeworkScreen()),
      ]),
      _NavGroup('more', Icons.cake_rounded, 'Birthdays', [
        const _SubPage('Birthdays', BirthdaysScreen()),
      ]),
    ],
    UserRole.parent => [
      _NavGroup('home', Icons.home_rounded, 'Home', [
        const _SubPage('Overview',   DashboardScreen()),
        const _SubPage('My Profile', ProfileScreen()),
      ]),
      _NavGroup('info', Icons.menu_book_rounded, 'Info', [
        const _SubPage('Timetable', TimetableScreen()),
        const _SubPage('Results',   ResultsScreen()),
      ]),
      _NavGroup('school', Icons.school_rounded, 'School', [
        const _SubPage('Notices',  NoticesScreen()),
        const _SubPage('Homework', HomeworkScreen()),
      ]),
      _NavGroup('more', Icons.cake_rounded, 'Birthdays', [
        const _SubPage('Birthdays', BirthdaysScreen()),
      ]),
    ],
    UserRole.admin => [
      _NavGroup('home',   Icons.home_rounded,    'Home',    [const _SubPage('Overview', DashboardScreen())]),
      _NavGroup('users',  Icons.group_rounded,   'Users',   [const _SubPage('All Users', AdminScreen())]),
      _NavGroup('manage', Icons.edit_note_rounded,'Manage', [
        const _SubPage('Notices',  NoticesScreen()),
        const _SubPage('Homework', HomeworkScreen()),
      ]),
    ],
    _ => [],
  };

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final user = prov.currentUser;
    if (user == null) return const LoginScreen();

    final groups = _groups(user.role);
    final grp    = groups[_groupIdx];
    final subs   = grp.subs;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 30, height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: ClipOval(child: Image.asset('assets/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_,__,___) => Center(
                  child: Text('MA', style: GoogleFonts.playfairDisplay(
                      fontSize: 11, fontWeight: FontWeight.w900,
                      color: AppColors.gold))))),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Modern Academy',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.gold)),
            Text('School Portal · Belur',
                style: GoogleFonts.dmSans(
                    fontSize: 9, color: AppColors.white.withOpacity(0.4),
                    letterSpacing: 0.8)),
          ]),
        ]),
        actions: [
          // Role badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Text(user.roleName,
                style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gold)),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            tooltip: 'Sign out',
            onPressed: () {
              prov.logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),

      // Sub-page tab bar at top
      body: Column(children: [
        if (subs.length > 1)
          Container(
            color: AppColors.white,
            child: Row(children: List.generate(subs.length, (i) {
              final active = i == _subIdx;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _subIdx = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: active ? AppColors.gold : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Text(subs[i].label,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w500,
                          color: active ? AppColors.navy : AppColors.muted,
                        )),
                  ),
                ),
              );
            })),
          ),
        const Divider(height: 1),
        Expanded(child: subs[_subIdx].screen),
      ]),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _groupIdx,
        onTap: (i) => setState(() { _groupIdx = i; _subIdx = 0; }),
        items: groups.map((g) => BottomNavigationBarItem(
          icon: Icon(g.icon),
          label: g.label,
        )).toList(),
      ),
    );
  }
}
