enum UserRole { student, teacher, parent, admin }

class UserModel {
  final String id;
  final String name;
  final UserRole role;
  final String phone;
  final String email;
  // student
  final String? cls;
  final String? dob;
  // teacher
  final String? subject;
  final String? classTeacher;
  // parent
  final List<String> wards;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    this.cls,
    this.dob,
    this.subject,
    this.classTeacher,
    this.wards = const [],
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  String get roleName => role.name[0].toUpperCase() + role.name.substring(1);
}

class Notice {
  String id;
  String cls; // 'ALL' or class name
  String icon;
  String tag;
  String tagType; // urgent | info | event
  String date;
  String title;
  String body;
  String postedBy;

  Notice({
    required this.id,
    required this.cls,
    required this.icon,
    required this.tag,
    required this.tagType,
    required this.date,
    required this.title,
    required this.body,
    this.postedBy = '',
  });
}

class Homework {
  String id;
  String cls;
  String subject;
  String task;
  String due;
  String postedBy;

  Homework({
    required this.id,
    required this.cls,
    required this.subject,
    required this.task,
    required this.due,
    this.postedBy = '',
  });
}

class ResultEntry {
  final String subject;
  final int marks;
  final int max;

  const ResultEntry({required this.subject, required this.marks, required this.max});

  double get percentage => marks / max * 100;

  String get grade {
    if (percentage >= 75) return 'A';
    if (percentage >= 60) return 'B';
    if (percentage >= 45) return 'C';
    return 'D';
  }
}

class TimetableSlot {
  final String time;
  final String subject;

  const TimetableSlot({required this.time, required this.subject});

  bool get isBreak =>
      subject.contains('Break') ||
      subject.contains('Lunch') ||
      subject.contains('Assembly');
}

class BirthdayStatus {
  final String status; // today | week | month | future
  final String label;
  final int days;
  const BirthdayStatus({required this.status, required this.label, required this.days});
}
