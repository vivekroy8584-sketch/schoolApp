import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});
  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  Homework? _editing;
  bool _showForm = false;
  final _taskCtrl = TextEditingController();
  final _dueCtrl  = TextEditingController();
  String _subject = 'Mathematics';

  final _subjects = ['Mathematics','English','Physics','Chemistry','Biology',
      'History','Geography','Bengali','Hindi','Computer Sc.','Science','Moral Science'];

  void _openForm([Homework? h]) {
    _editing    = h;
    _taskCtrl.text = h?.task ?? '';
    _dueCtrl.text  = h?.due  ?? '';
    _subject    = h?.subject ?? 'Mathematics';
    setState(() => _showForm = true);
  }

  void _save(AppProvider prov) {
    if (_taskCtrl.text.trim().isEmpty || _dueCtrl.text.trim().isEmpty) return;
    if (_editing != null) {
      _editing!.subject = _subject;
      _editing!.task    = _taskCtrl.text.trim();
      _editing!.due     = _dueCtrl.text.trim();
      prov.updateHomework(_editing!);
    } else {
      prov.addHomework(Homework(
        id: 'HW${DateTime.now().millisecondsSinceEpoch}',
        cls: prov.currentUser?.classTeacher ?? '',
        subject: _subject,
        task: _taskCtrl.text.trim(),
        due: _dueCtrl.text.trim(),
        postedBy: prov.currentUser?.id ?? '',
      ));
    }
    setState(() { _showForm = false; _editing = null; });
  }

  @override
  Widget build(BuildContext context) {
    final prov    = context.watch<AppProvider>();
    final canEdit = prov.currentUser?.role == UserRole.teacher
        && prov.currentUser?.classTeacher != null;
    final isStudent = prov.currentUser?.role == UserRole.student;
    final hwList  = prov.homeworkForUser();

    return Column(children: [
      Row(children: [
        const Expanded(child: PageHeader(tag: 'Assignments', title: 'Homework')),
        if (canEdit)
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: FilledButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy, foregroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: GoogleFonts.dmSans(fontSize: 13)),
            ),
          ),
      ]),

      if (_showForm) _buildForm(prov),

      Expanded(child: hwList.isEmpty
        ? const EmptyState(emoji: '📚', message: 'No homework for this class')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16,4,16,24),
            itemCount: hwList.length,
            itemBuilder: (_, i) {
              final h = hwList[i];
              final done = prov.hwDone(h.id);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (isStudent)
                    GestureDetector(
                      onTap: () => prov.toggleHw(h.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22, height: 22,
                        margin: const EdgeInsets.only(top: 1, right: 12),
                        decoration: BoxDecoration(
                          color: done ? AppColors.green : Colors.transparent,
                          border: Border.all(
                              color: done ? AppColors.green : AppColors.border,
                              width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: done ? const Icon(Icons.check, size: 14,
                            color: Colors.white) : null,
                      ),
                    ),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h.subject.toUpperCase(),
                        style: GoogleFonts.dmSans(fontSize: 10,
                            fontWeight: FontWeight.w600, color: AppColors.gold,
                            letterSpacing: 0.8)),
                    const SizedBox(height: 3),
                    Text(h.task,
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: AppColors.navy,
                            fontWeight: FontWeight.w500,
                            decoration: done ? TextDecoration.lineThrough : null,
                            decorationColor: AppColors.muted),
                        maxLines: isStudent ? 3 : null),
                    const SizedBox(height: 4),
                    Text('Due: ${h.due}',
                        style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                    if (canEdit) ...[
                      const SizedBox(height: 6),
                      Row(children: [
                        TextButton.icon(onPressed: () => _openForm(h),
                            icon: const Icon(Icons.edit_outlined, size: 14),
                            label: const Text('Edit', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(foregroundColor: AppColors.navy,
                                padding: const EdgeInsets.symmetric(horizontal: 6))),
                        TextButton.icon(onPressed: () => prov.deleteHomework(h.id),
                            icon: const Icon(Icons.delete_outline, size: 14),
                            label: const Text('Delete', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(foregroundColor: AppColors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 6))),
                      ]),
                    ],
                  ])),
                ]),
              );
            },
          )),
    ]);
  }

  Widget _buildForm(AppProvider prov) => Container(
    margin: const EdgeInsets.fromLTRB(16,0,16,8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_editing != null ? 'Edit Homework' : 'New Homework',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w600,
              fontSize: 14, color: AppColors.navy)),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        value: _subject,
        decoration: const InputDecoration(labelText: 'Subject'),
        items: _subjects.map((s) =>
            DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _subject = v ?? _subject),
      ),
      const SizedBox(height: 8),
      TextField(controller: _taskCtrl, maxLines: 3,
          decoration: const InputDecoration(hintText: 'Assignment description')),
      const SizedBox(height: 8),
      TextField(controller: _dueCtrl,
          decoration: const InputDecoration(hintText: 'Due date (e.g. 10 Oct 2026)')),
      const SizedBox(height: 10),
      Row(children: [
        ElevatedButton(onPressed: () => _save(prov),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(0,36),
                padding: const EdgeInsets.symmetric(horizontal: 18)),
            child: Text(_editing != null ? 'Save' : 'Post')),
        const SizedBox(width: 8),
        TextButton(onPressed: () => setState(() { _showForm=false; _editing=null; }),
            child: const Text('Cancel')),
      ]),
    ]),
  );
}
