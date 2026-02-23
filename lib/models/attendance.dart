import 'package:intl/intl.dart';

class Attendance {
  final int id;
  final int clientId;
  final DateTime attendanceDate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  Attendance({
    required this.id,
    required this.clientId,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
  });

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