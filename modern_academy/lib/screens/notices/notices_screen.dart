import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});
  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  Notice? _editing;
  bool _showForm = false;

  // form controllers
  final _titleCtrl = TextEditingController();
  final _bodyCtrl  = TextEditingController();
  String _icon = '📢';
  String _tag  = 'Info';

  void _openForm([Notice? n]) {
    _editing = n;
    _titleCtrl.text = n?.title ?? '';
    _bodyCtrl.text  = n?.body  ?? '';
    _icon = n?.icon ?? '📢';
    _tag  = n?.tag  ?? 'Info';
    setState(() => _showForm = true);
  }

  void _save(AppProvider prov) {
    if (_titleCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) return;
    final tagTypeMap = {'Urgent':'urgent','Academic':'info','Event':'event','Info':'info'};
    final now = DateTime.now();
    final date = '${now.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][now.month-1]} ${now.year}';
    if (_editing != null) {
      _editing!.title   = _titleCtrl.text.trim();
      _editing!.body    = _bodyCtrl.text.trim();
      _editing!.icon    = _icon;
      _editing!.tag     = _tag;
      _editing!.tagType = tagTypeMap[_tag] ?? 'info';
      prov.updateNotice(_editing!);
    } else {
      prov.addNotice(Notice(
        id: 'N${DateTime.now().millisecondsSinceEpoch}',
        cls: prov.currentUser?.classTeacher ?? 'ALL',
        icon: _icon, tag: _tag,
        tagType: tagTypeMap[_tag] ?? 'info',
        date: date,
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
        postedBy: prov.currentUser?.id ?? '',
      ));
    }
    setState(() { _showForm = false; _editing = null; });
  }

  @override
  Widget build(BuildContext context) {
    final prov     = context.watch<AppProvider>();
    final canEdit  = prov.currentUser?.role == UserRole.teacher
        && prov.currentUser?.classTeacher != null
        || prov.currentUser?.role == UserRole.admin;
    final notices  = prov.noticesForUser();

    return Column(children: [
      Row(children: [
        const Expanded(child: PageHeader(tag: 'Announcements', title: 'Notices')),
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

      Expanded(child: notices.isEmpty
        ? const EmptyState(emoji: '📢', message: 'No notices at this time')
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16,4,16,24),
            itemCount: notices.length,
            itemBuilder: (_, i) => _NoticeCard(
              notice: notices[i], canEdit: canEdit,
              onEdit: () => _openForm(notices[i]),
              onDelete: () => prov.deleteNotice(notices[i].id),
            ),
          )),
    ]);
  }

  Widget _buildForm(AppProvider prov) {
    final icons = ['📢','📝','🏆','📚','🎉','ℹ️','⚠️','📌'];
    final tags  = ['Urgent','Academic','Event','Info'];
    return StatefulBuilder(builder: (ctx, setLocal) => Container(
      margin: const EdgeInsets.fromLTRB(16,0,16,8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_editing != null ? 'Edit Notice' : 'New Notice',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600,
                fontSize: 14, color: AppColors.navy)),
        const SizedBox(height: 10),
        // Icon row
        Row(children: icons.map((ic) => GestureDetector(
          onTap: () => setState(() => _icon = ic),
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _icon == ic ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(ic, style: const TextStyle(fontSize: 16)),
          ),
        )).toList()),
        const SizedBox(height: 8),
        // Tag chips
        Wrap(spacing: 6, children: tags.map((t) => ChoiceChip(
          label: Text(t, style: GoogleFonts.dmSans(fontSize: 12)),
          selected: _tag == t,
          onSelected: (_) => setState(() => _tag = t),
          selectedColor: AppColors.navy,
          labelStyle: TextStyle(color: _tag == t ? AppColors.gold : AppColors.muted),
          side: BorderSide(color: AppColors.border),
        )).toList()),
        const SizedBox(height: 10),
        TextField(controller: _titleCtrl,
            decoration: const InputDecoration(hintText: 'Notice title')),
        const SizedBox(height: 8),
        TextField(controller: _bodyCtrl, maxLines: 3,
            decoration: const InputDecoration(hintText: 'Notice body')),
        const SizedBox(height: 10),
        Row(children: [
          ElevatedButton(onPressed: () => _save(prov),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 18)),
              child: Text(_editing != null ? 'Save' : 'Post')),
          const SizedBox(width: 8),
          TextButton(onPressed: () => setState(() { _showForm=false; _editing=null; }),
              child: const Text('Cancel')),
        ]),
      ]),
    ));
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _NoticeCard({required this.notice, required this.canEdit,
    required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(notice.icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Expanded(child: Text(notice.title,
            style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600,
                color: AppColors.navy))),
        TagBadge(label: notice.tag, type: notice.tagType),
      ]),
      const SizedBox(height: 4),
      Text(notice.date, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
      const SizedBox(height: 6),
      Text(notice.body,
          style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF374151),
              height: 1.5)),
      if (canEdit) ...[
        const SizedBox(height: 8),
        Row(children: [
          TextButton.icon(onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 14),
              label: const Text('Edit', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(foregroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(horizontal: 8))),
          TextButton.icon(onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 14),
              label: const Text('Delete', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(foregroundColor: AppColors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 8))),
        ]),
      ],
    ]),
  );
}
