import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/app_data.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _currentUser;
  String? _activeWard;
  final Map<String, bool> _hwDone = {};
  final List<Notice> _notices = [
    Notice(id:'N1',cls:'ALL',icon:'📢',tag:'Urgent',tagType:'urgent',date:'6 Oct 2026',title:'Parent-Teacher Meeting — 15 Oct 2026',body:'All parents are requested to attend the Parent-Teacher Meeting on 15th October 2026 from 9:00 AM to 1:00 PM. Please collect the meeting slip from the school office.',postedBy:'T001'),
    Notice(id:'N2',cls:'X-A',icon:'📝',tag:'Academic',tagType:'info',date:'4 Oct 2026',title:'Unit Test 2 Syllabus — Class X-A',body:'Mathematics: Ch 5-6. English: Poem 3, Prose Ch 4. Physics: Ch 3. Chemistry: Ch 2-3. Revision classes will be held every Friday.',postedBy:'T002'),
    Notice(id:'N3',cls:'ALL',icon:'🏆',tag:'Event',tagType:'event',date:'3 Oct 2026',title:'Annual Sports Day — 25 Oct 2026',body:'Annual Sports Day will be held on 25th October 2026. Students interested in participating must register with their class teacher by 12th October.',postedBy:'T001'),
    Notice(id:'N4',cls:'IX-B',icon:'📚',tag:'Info',tagType:'info',date:'1 Oct 2026',title:'Library Submission — Class IX-B',body:'All students of Class IX-B who have borrowed library books must return them by 10th October. Fine of ₹5/day for late returns.',postedBy:'T003'),
  ];
  final List<Homework> _homework = [
    Homework(id:'HW1',cls:'X-A',subject:'Mathematics',task:'Complete Exercise 5.3 — Q1 to Q10 (Quadratic Equations)',due:'8 Oct 2026',postedBy:'T002'),
    Homework(id:'HW2',cls:'X-A',subject:'English',task:'Write a 300-word essay on "The Importance of Discipline in School Life"',due:'9 Oct 2026',postedBy:'T002'),
    Homework(id:'HW3',cls:'X-A',subject:'Physics',task:'Solve numericals from Chapter 3 (Laws of Motion), page 58–59',due:'7 Oct 2026',postedBy:'T002'),
    Homework(id:'HW4',cls:'IX-B',subject:'English',task:'Write a summary of Chapter 2. Underline key vocabulary words.',due:'8 Oct 2026',postedBy:'T003'),
    Homework(id:'HW5',cls:'IX-B',subject:'Bengali',task:'সারসংক্ষেপ — "আমার সোনার বাংলা" কবিতার সারাংশ লেখো (১৫০ শব্দ)',due:'10 Oct 2026',postedBy:'T003'),
    Homework(id:'HW6',cls:'VIII-C',subject:'Science',task:'Draw and label the diagram of the water cycle with all stages.',due:'9 Oct 2026',postedBy:'T004'),
  ];

  UserModel? get currentUser => _currentUser;
  String? get activeWard => _activeWard;
  List<Notice> get notices => List.unmodifiable(_notices);
  List<Homework> get homework => List.unmodifiable(_homework);
  bool hwDone(String id) => _hwDone[id] ?? false;

  // ── AUTH ──────────────────────────────────────────────────────────────
  bool login(String id, String password) {
    final upperID = id.toUpperCase();
    if (userPasswords[upperID] != password) return false;
    final user = users[upperID];
    if (user == null) return false;
    _currentUser = user;
    _activeWard = user.wards.isNotEmpty ? user.wards.first : null;
    _hwDone.clear();
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _activeWard = null;
    _hwDone.clear();
    notifyListeners();
  }

  // ── WARD ──────────────────────────────────────────────────────────────
  void setActiveWard(String wardId) {
    _activeWard = wardId;
    notifyListeners();
  }

  UserModel? get activeWardUser => _activeWard != null ? users[_activeWard] : null;

  // ── HOMEWORK STATE ─────────────────────────────────────────────────────
  void toggleHw(String id) {
    _hwDone[id] = !(_hwDone[id] ?? false);
    notifyListeners();
  }

  // ── FILTERED DATA ─────────────────────────────────────────────────────
  List<Notice> noticesForUser() {
    final u = _currentUser;
    if (u == null) return [];
    if (u.role == UserRole.admin) return _notices;
    String cls = '';
    if (u.role == UserRole.student) cls = u.cls ?? '';
    else if (u.role == UserRole.teacher) cls = u.classTeacher ?? 'ALL';
    else if (u.role == UserRole.parent) cls = activeWardUser?.cls ?? 'ALL';
    return _notices.where((n) => n.cls == 'ALL' || n.cls == cls).toList();
  }

  List<Homework> homeworkForUser() {
    final u = _currentUser;
    if (u == null) return [];
    if (u.role == UserRole.admin) return _homework;
    String cls = '';
    if (u.role == UserRole.student) cls = u.cls ?? '';
    else if (u.role == UserRole.teacher) cls = u.classTeacher ?? '';
    else if (u.role == UserRole.parent) cls = activeWardUser?.cls ?? '';
    return _homework.where((h) => h.cls == cls).toList();
  }

  List<UserModel> get allStudents =>
      users.values.where((u) => u.role == UserRole.student).toList();

  // ── CRUD NOTICES ──────────────────────────────────────────────────────
  void addNotice(Notice n) { _notices.insert(0, n); notifyListeners(); }
  void updateNotice(Notice n) {
    final i = _notices.indexWhere((x) => x.id == n.id);
    if (i >= 0) { _notices[i] = n; notifyListeners(); }
  }
  void deleteNotice(String id) {
    _notices.removeWhere((n) => n.id == id); notifyListeners();
  }

  // ── CRUD HOMEWORK ─────────────────────────────────────────────────────
  void addHomework(Homework h) { _homework.insert(0, h); notifyListeners(); }
  void updateHomework(Homework h) {
    final i = _homework.indexWhere((x) => x.id == h.id);
    if (i >= 0) { _homework[i] = h; notifyListeners(); }
  }
  void deleteHomework(String id) {
    _homework.removeWhere((h) => h.id == id); notifyListeners();
  }

  // ── BIRTHDAY HELPERS ──────────────────────────────────────────────────
  static BirthdayStatus bdayStatus(String dob) {
    final parts = dob.split('-');
    final m = int.parse(parts[1]);
    final d = int.parse(parts[2]);
    final now = DateTime.now();
    if (m == now.month && d == now.day) {
      return const BirthdayStatus(status:'today', label:'Today 🎂', days:0);
    }
    var next = DateTime(now.year, m, d);
    if (next.isBefore(now)) next = DateTime(now.year + 1, m, d);
    final diff = next.difference(now).inDays;
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    if (diff <= 7)  return BirthdayStatus(status:'week',  label:'In $diff day${diff==1?"":"s"}', days:diff);
    if (diff <= 31) return BirthdayStatus(status:'month', label:'In $diff days', days:diff);
    return BirthdayStatus(status:'future', label:'${months[m-1]} $d', days:diff);
  }

  static String formatDob(String dob) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final parts = dob.split('-');
    return '${months[int.parse(parts[1])-1]} ${parts[2]}';
  }
}
