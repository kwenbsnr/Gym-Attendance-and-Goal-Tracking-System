import 'package:intl/intl.dart';

class Attendance {
  final int attendanceId;
  final int clientId;
  final DateTime attendanceDate;
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;

  Attendance({
    required this.attendanceId,
    required this.clientId,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
  });

  bool get isCheckedIn => checkInTime != null;
  bool get isCheckedOut => checkOutTime != null;
  
  String get formattedCheckInTime {
    if (checkInTime == null) return 'Not checked in';
    return checkInTime!.format(context);
  }
  
  String get formattedCheckOutTime {
    if (checkOutTime == null) return 'Not checked out';
    return checkOutTime!.format(context);
  }
  
  Duration? get duration {
    if (checkInTime != null && checkOutTime != null) {
      DateTime checkInDateTime = DateTime(
        attendanceDate.year,
        attendanceDate.month,
        attendanceDate.day,
        checkInTime!.hour,
        checkInTime!.minute,
      );
      DateTime checkOutDateTime = DateTime(
        attendanceDate.year,
        attendanceDate.month,
        attendanceDate.day,
        checkOutTime!.hour,
        checkOutTime!.minute,
      );
      return checkOutDateTime.difference(checkInDateTime);
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
    return {
      'attendance_id': attendanceId,
      'client_id': clientId,
      'attendance_date': attendanceDate.toIso8601String(),
      'check_in_time': checkInTime != null 
          ? '${checkInTime!.hour.toString().padLeft(2, '0')}:${checkInTime!.minute.toString().padLeft(2, '0')}:00'
          : null,
      'check_out_time': checkOutTime != null
          ? '${checkOutTime!.hour.toString().padLeft(2, '0')}:${checkOutTime!.minute.toString().padLeft(2, '0')}:00'
          : null,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    TimeOfDay? parseTime(String? timeStr) {
      if (timeStr == null) return null;
      final parts = timeStr.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return Attendance(
      attendanceId: map['attendance_id'],
      clientId: map['client_id'],
      attendanceDate: DateTime.parse(map['attendance_date']),
      checkInTime: parseTime(map['check_in_time']),
      checkOutTime: parseTime(map['check_out_time']),
    );
  }

  static BuildContext? get context => null;
}