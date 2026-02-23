import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_try_0/database/database_helper.dart';
import 'package:flutter_application_try_0/models/client.dart';

class ClientDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // CREATE
  Future<int> insertClient(Client client) async {
    final Database db = await _dbHelper.database;
    return await db.insert('CLIENT', {
      'first_name': client.firstName,
      'last_name': client.lastName,
      'height_cm': client.heightCm,
      'current_weight_kg': client.currentWeightKg,
      'gender': client.gender,
      'date_of_birth': client.dateOfBirth?.toIso8601String(),
      'contact_number': client.contactNumber,
      'email': client.email,
      'emergency_contact': client.emergencyContact,
      'medical_notes': client.medicalNotes,
      'date_registered': client.dateRegistered.toIso8601String(),
    });
  }

  // READ - All clients
  Future<List<Client>> getAllClients() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('CLIENT');
    
    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }

  // READ - Single client
  Future<Client?> getClient(int clientId) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'CLIENT',
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
    
    if (maps.isNotEmpty) {
      return Client.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE
  Future<int> updateClient(Client client) async {
    final Database db = await _dbHelper.database;
    return await db.update(
      'CLIENT',
      {
        'first_name': client.firstName,
        'last_name': client.lastName,
        'height_cm': client.heightCm,
        'current_weight_kg': client.currentWeightKg,
        'gender': client.gender,
        'date_of_birth': client.dateOfBirth?.toIso8601String(),
        'contact_number': client.contactNumber,
        'email': client.email,
        'emergency_contact': client.emergencyContact,
        'medical_notes': client.medicalNotes,
      },
      where: 'client_id = ?',
      whereArgs: [client.clientId],
    );
  }

  // DELETE
  Future<int> deleteClient(int clientId) async {
    final Database db = await _dbHelper.database;
    return await db.delete(
      'CLIENT',
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }

  // SEARCH
  Future<List<Client>> searchClients(String query) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'CLIENT',
      where: 'first_name LIKE ? OR last_name LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    
    return List.generate(maps.length, (i) => Client.fromMap(maps[i]));
  }

  // Get client count
  Future<int> getClientCount() async {
    final Database db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM CLIENT');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}