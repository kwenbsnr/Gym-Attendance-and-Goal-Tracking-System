import 'package:intl/intl.dart';

class Attendance {
  final int attendanceId;
  final int clientId;
  final DateTime attendanceDate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  Attendance({
    int? id,
    int? attendanceId,
    required this.clientId,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
  }) : attendanceId = attendanceId ?? id ?? 0;

  int get id => attendanceId;
  bool get isCheckedIn => checkInTime != null;
  bool get isCheckedOut => checkOutTime != null;
  
  String get formattedCheckInTime {
    if (checkInTime == null) return 'Not checked in';
    return DateFormat('hh:mm a').format(checkInTime!);
  }
  
  String get formattedCheckOutTime {
    if (checkOutTime == null) return 'Not checked out';
    return DateFormat('hh:mm a').format(checkOutTime!);
  }
  
  Duration? get duration {
    if (checkInTime != null && checkOutTime != null) {
      return checkOutTime!.difference(checkInTime!);
    }
    return null;
  }
  
  String get formattedDuration {
    final dur = duration;
    if (dur == null) return '--';
    final hours = dur.inHours;
    final minutes = dur.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Map<String, dynamic> toMap() {
    String? formatTime(DateTime? dt) {
      if (dt == null) return null;
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    }

    return {
      'attendance_id': attendanceId,
      'client_id': clientId,
      'attendance_date': attendanceDate.toIso8601String(),
      'check_in_time': formatTime(checkInTime),
      'check_out_time': formatTime(checkOutTime),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    final date = DateTime.parse(map['attendance_date']);

    DateTime? parseDateTimeOrTime(dynamic val, DateTime baseDate) {
      if (val == null) return null;
      if (val is DateTime) return val;
      final timeStr = val.toString();
      if (timeStr.isEmpty) return null;
      if (timeStr.contains('T')) {
        return DateTime.tryParse(timeStr);
      }
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        final s = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
        return DateTime(baseDate.year, baseDate.month, baseDate.day, h, m, s);
      }
      return null;
    }

    return Attendance(
      attendanceId: map['attendance_id'] ?? map['id'] ?? 0,
      clientId: map['client_id'] ?? 0,
      attendanceDate: date,
      checkInTime: parseDateTimeOrTime(map['check_in_time'], date),
      checkOutTime: parseDateTimeOrTime(map['check_out_time'], date),
    );
  }
}

// Sample data for UI development
List<Attendance> sampleAttendance = [
  Attendance(
    id: 1,
    clientId: 1,
    attendanceDate: DateTime.now(),
    checkInTime: DateTime.now().subtract(const Duration(hours: 2)),
    checkOutTime: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  Attendance(
    id: 2,
    clientId: 2,
    attendanceDate: DateTime.now(),
    checkInTime: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Attendance(
    id: 3,
    clientId: 3,
    attendanceDate: DateTime.now().subtract(const Duration(days: 1)),
    checkInTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    checkOutTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
  ),
  Attendance(
    id: 4,
    clientId: 1,
    attendanceDate: DateTime.now().subtract(const Duration(days: 2)),
    checkInTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    checkOutTime: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
  ),
  Attendance(
    id: 5,
    clientId: 2,
    attendanceDate: DateTime.now().subtract(const Duration(days: 3)),
    checkInTime: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
    checkOutTime: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
  ),
  Attendance(
    id: 6,
    clientId: 3,
    attendanceDate: DateTime.now().subtract(const Duration(days: 4)),
    checkInTime: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
  ),
];