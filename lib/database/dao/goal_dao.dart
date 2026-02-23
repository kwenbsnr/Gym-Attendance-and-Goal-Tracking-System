import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_try_0/database/database_helper.dart';
import 'package:flutter_application_try_0/models/goal.dart';

class GoalDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // CREATE goal
  Future<int> createGoal(Goal goal) async {
    final Database db = await _dbHelper.database;
    return await db.insert('GOAL', {
      'goal_name': goal.goalName,
      'goal_description': goal.goalDescription,
    });
  }

  // READ all goals
  Future<List<Goal>> getAllGoals() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('GOAL');
    
    return List.generate(maps.length, (i) {
      return Goal.fromMap(maps[i]);
    });
  }

  // ASSIGN goal to client
  Future<int> assignGoalToClient(ClientGoal clientGoal) async {
    final Database db = await _dbHelper.database;
    return await db.insert('CLIENT_GOAL', {
      'client_id': clientGoal.clientId,
      'goal_id': clientGoal.goalId,
      'target_days_per_week': clientGoal.targetDaysPerWeek,
      'client_goal_start_date': clientGoal.startDate.toIso8601String(),
      'client_goal_status': clientGoal.status,
    });
  }

  // Get client's goals
  Future<List<ClientGoal>> getClientGoals(int clientId) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'CLIENT_GOAL',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'client_goal_start_date DESC',
    );
    
    return List.generate(maps.length, (i) {
      return ClientGoal.fromMap(maps[i]);
    });
  }

  // Get clients by goal
  Future<List<Map<String, dynamic>>> getClientsByGoal(int goalId) async {
    final Database db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT 
        c.client_id,
        c.first_name,
        c.last_name,
        cg.target_days_per_week,
        cg.client_goal_start_date,
        cg.client_goal_status
      FROM CLIENT_GOAL cg
      JOIN CLIENT c ON cg.client_id = c.client_id
      WHERE cg.goal_id = ?
      ORDER BY cg.client_goal_start_date DESC
    ''', [goalId]);
  }

  // Update goal status
  Future<int> updateGoalStatus(int clientGoalId, String status) async {
    final Database db = await _dbHelper.database;
    return await db.update(
      'CLIENT_GOAL',
      {'client_goal_status': status},
      where: 'client_goal_id = ?',
      whereArgs: [clientGoalId],
    );
  }

  // Get goal participation statistics
  Future<Map<String, int>> getGoalStats() async {
    final Database db = await _dbHelper.database;
    
    final result = await db.rawQuery('''
      SELECT 
        g.goal_name,
        COUNT(cg.client_goal_id) as count
      FROM GOAL g
      LEFT JOIN CLIENT_GOAL cg ON g.goal_id = cg.goal_id AND cg.client_goal_status = 'Ongoing'
      GROUP BY g.goal_id
    ''');
    
    Map<String, int> stats = {};
    for (var row in result) {
      stats[row['goal_name'] as String] = row['count'] as int;
    }
    return stats;
  }

  // Get total ongoing goals count
  Future<int> getOngoingGoalsCount() async {
    final Database db = await _dbHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM CLIENT_GOAL WHERE client_goal_status = "Ongoing"'
    )) ?? 0;
  }
}