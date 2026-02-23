import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_try_0/database/database_helper.dart';
import 'package:flutter_application_try_0/models/goal.dart';

class GoalDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Create new goal
  Future<int> createGoal(Goal goal) async {
    Database db = await _dbHelper.database;
    return await db.insert('goal', {
      'goal_name': goal.goalName,
      'goal_description': goal.goalDescription,
    });
  }

  // Get all goals
  Future<List<Goal>> getAllGoals() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('goal');
    
    return List.generate(maps.length, (i) {
      return Goal(
        id: maps[i]['goal_id'],
        goalName: maps[i]['goal_name'],
        goalDescription: maps[i]['goal_description'],
      );
    });
  }

  // Assign goal to client
  Future<int> assignGoalToClient(ClientGoal clientGoal) async {
    Database db = await _dbHelper.database;
    return await db.insert('client_goal', {
      'client_id': clientGoal.clientId,
      'goal_id': clientGoal.goalId,
      'target_days_per_week': clientGoal.targetDaysPerWeek,
      'client_goal_start_date': clientGoal.startDate.toIso8601String(),
      'client_goal_status': clientGoal.status,
    });
  }

  // Get client goals
  Future<List<Map<String, dynamic>>> getClientGoals(int clientId) async {
    Database db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT g.goal_name, g.goal_description, 
             cg.target_days_per_week, cg.client_goal_start_date,
             cg.client_goal_status
      FROM client_goal cg
      JOIN goal g ON cg.goal_id = g.goal_id
      WHERE cg.client_id = ?
      ORDER BY cg.client_goal_start_date DESC
    ''', [clientId]);
  }

  // Get goal participation stats
  Future<Map<String, int>> getGoalStats() async {
    Database db = await _dbHelper.database;
    
    final result = await db.rawQuery('''
      SELECT g.goal_name, COUNT(cg.client_goal_id) as count
      FROM goal g
      LEFT JOIN client_goal cg ON g.goal_id = cg.goal_id
      WHERE cg.client_goal_status = 'Ongoing'
      GROUP BY g.goal_id
    ''');
    
    Map<String, int> stats = {};
    for (var row in result) {
      stats[row['goal_name'] as String] = row['count'] as int;
    }
    return stats;
  }
}