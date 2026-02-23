import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_try_0/database/database_helper.dart';
import 'package:flutter_application_try_0/models/attendance.dart';

class AttendanceDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // CHECK IN
  Future<int> checkIn(int clientId) async {
    final Database db = await _dbHelper.database;
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    
    return await db.insert('ATTENDANCE', {
      'client_id': clientId,
      'attendance_date': now.toIso8601String(),
      'check_in_time': timeStr,
    });
  }

  // CHECK OUT
  Future<int> checkOut(int attendanceId) async {
    final Database db = await _dbHelper.database;
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    
    return await db.update(
      'ATTENDANCE',
      {'check_out_time': timeStr},
      where: 'attendance_id = ?',
      whereArgs: [attendanceId],
    );
  }

  // Get today's attendance
  Future<List<Attendance>> getTodayAttendance() async {
    final Database db = await _dbHelper.database;
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.query(
      'ATTENDANCE',
      where: 'attendance_date LIKE ?',
      whereArgs: ['$todayStr%'],
      orderBy: 'check_in_time DESC',
    );
    
    return List.generate(maps.length, (i) => Attendance.fromMap(maps[i]));
  }

  // Get client's last attendance
  Future<Attendance?> getLastAttendance(int clientId) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ATTENDANCE',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'attendance_date DESC',
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return Attendance.fromMap(maps.first);
    }
    return null;
  }

  // Get client's attendance history
  Future<List<Attendance>> getClientAttendance(int clientId) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ATTENDANCE',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'attendance_date DESC',
    );
    
    return List.generate(maps.length, (i) => Attendance.fromMap(maps[i]));
  }

  // Get weekly attendance summary
  Future<Map<String, int>> getWeeklyAttendance() async {
    final Database db = await _dbHelper.database;
    Map<String, int> result = {};
    
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T')[0];
      
      final count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ATTENDANCE WHERE attendance_date LIKE ?',
        ['$dateStr%']
      )) ?? 0;
      
      final dayName = _getShortDayName(date.weekday);
      result[dayName] = count;
    }
    
    return result;
  }

  // Get today's check-in count
  Future<int> getTodayCheckInCount() async {
    final Database db = await _dbHelper.database;
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];
    
    return Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM ATTENDANCE WHERE attendance_date LIKE ?',
      ['$todayStr%']
    )) ?? 0;
  }

  String _getShortDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  // Find active check-in (checked in but not checked out)
  Future<Attendance?> findActiveCheckIn(int clientId) async {
    final Database db = await _dbHelper.database;
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.query(
      'ATTENDANCE',
      where: 'client_id = ? AND attendance_date LIKE ? AND check_in_time IS NOT NULL AND check_out_time IS NULL',
      whereArgs: [clientId, '$todayStr%'],
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return Attendance.fromMap(maps.first);
    }
    return null;
  }
}