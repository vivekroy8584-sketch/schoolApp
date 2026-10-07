import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../data/app_data.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final students = prov.allStudents;
    final teachers = users.values.where((u) => u.role == UserRole.teacher).toList();
    final parents  = users.values.where((u) => u.role == UserRole.parent).toList();

    return Column(children: [
      const PageHeader(tag: 'Admin Panel', title: 'User Management'),
      Container(
        color: AppColors.white,
        child: TabBar(
          controller: _tab,
          labelColor: AppColors.navy,
          unselectedLabelColor: AppColors.muted,
          indicatorColor: AppColors.gold,
          indicatorWeight: 2.5,
          labelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Students (${students.length})'),
            Tab(text: 'Teachers (${teachers.length})'),
            Tab(text: 'Parents (${parents.length})'),
          ],
        ),
      ),
      const Divider(height: 1),
      Expanded(child: TabBarView(controller: _tab, children: [
        _UserList(users: students, columns: _studentCols),
        _UserList(users: teachers, columns: _teacherCols),
        _UserList(users: parents,  columns: _parentCols),
      ])),
    ]);
  }

  List<_Col> get _studentCols => [
    _Col('Name',    (u) => u.name),
    _Col('Roll',    (u) => u.id),
    _Col('Class',   (u) => u.cls ?? '—'),
    _Col('Phone',   (u) => u.phone),
  ];

  List<_Col> get _teacherCols => [
    _Col('Name',         (u) => u.name),
    _Col('ID',           (u) => u.id),
    _Col('Subject',      (u) => u.subject ?? '—'),
    _Col('Class Teacher',(u) => u.classTeacher ?? 'None'),
  ];

  List<_Col> get _parentCols => [
    _Col('Name',  (u) => u.name),
    _Col('ID',    (u) => u.id),
    _Col('Wards', (u) => u.wards.map((w) => users[w]?.name.split(' ').first ?? w).join(', ')),
    _Col('Phone', (u) => u.phone),
  ];
}

class _Col {
  final String header;
  final String Function(UserModel) value;
  const _Col(this.header, this.value);
}

class _UserList extends StatelessWidget {
  final List<UserModel> users;
  final List<_Col> columns;
  const _UserList({required this.users, required this.columns});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const EmptyState(emoji: '👥', message: 'No users found');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: AvatarCircle(initials: u.initials, size: 40),
            title: Text(u.name,
                style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy)),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns.skip(1).map((c) => Text(
                  '${c.header}: ${c.value(u)}',
                  style: GoogleFonts.dmSans(
                      fontSize: 11, color: AppColors.muted),
                )).toList()),
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Text(columns[0].value(u),
                  style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold)),
            ),
          ),
        );
      },
    );
  }
}
