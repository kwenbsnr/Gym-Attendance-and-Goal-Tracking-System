import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_try_0/database/database_helper.dart';
import 'package:flutter_application_try_0/models/subscription.dart';
import 'package:flutter_application_try_0/models/plan_type.dart';

class SubscriptionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get all plan types
  Future<List<PlanType>> getAllPlanTypes() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PLAN_TYPE');
    
    return List.generate(maps.length, (i) {
      return PlanType.fromMap(maps[i]);
    });
  }

  // Get all subscription plans
  Future<List<SubscriptionPlan>> getAllPlans() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('SUBSCRIPTION_PLAN');
    
    return List.generate(maps.length, (i) {
      return SubscriptionPlan.fromMap(maps[i]);
    });
  }

  // Get active plans (currently offered)
  Future<List<SubscriptionPlan>> getActivePlans() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'SUBSCRIPTION_PLAN',
      where: 'is_currently_offered = ?',
      whereArgs: [1],
    );
    
    return List.generate(maps.length, (i) {
      return SubscriptionPlan.fromMap(maps[i]);
    });
  }

  // CREATE subscription
  Future<int> createSubscription(ClientSubscription subscription) async {
    final Database db = await _dbHelper.database;
    return await db.insert('CURRENT_SUBSCRIPTION', subscription.toMap()..remove('subscription_id'));
  }

  // Get client's current subscription
  Future<ClientSubscription?> getClientSubscription(int clientId) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'CURRENT_SUBSCRIPTION',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'subscription_start DESC',
    );
    
    if (maps.isNotEmpty) {
      return ClientSubscription.fromMap(maps.first);
    }
    return null;
  }

  // Update subscription status
  Future<int> updateSubscriptionStatus(int subscriptionId, String status) async {
    final Database db = await _dbHelper.database;
    return await db.update(
      'CURRENT_SUBSCRIPTION',
      {'subscription_status': status},
      where: 'subscription_id = ?',
      whereArgs: [subscriptionId],
    );
  }

  // Get subscription statistics
  Future<Map<String, int>> getSubscriptionStats() async {
    final Database db = await _dbHelper.database;
    
    int active = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM CURRENT_SUBSCRIPTION WHERE subscription_status = "Active"'
    )) ?? 0;
    
    int expired = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM CURRENT_SUBSCRIPTION WHERE subscription_status = "Expired"'
    )) ?? 0;
    
    int paused = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM CURRENT_SUBSCRIPTION WHERE subscription_status = "Paused"'
    )) ?? 0;
    
    int expiringSoon = Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) FROM CURRENT_SUBSCRIPTION 
      WHERE subscription_status = "Active" 
      AND julianday(subscription_end) - julianday('now') <= 7
      AND julianday(subscription_end) - julianday('now') > 0
    ''')) ?? 0;
    
    return {
      'active': active,
      'expired': expired,
      'paused': paused,
      'expiringSoon': expiringSoon,
    };
  }

  // Get expiring soon subscriptions with client details
  Future<List<Map<String, dynamic>>> getExpiringSoonDetails() async {
    final Database db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT 
        c.client_id,
        c.first_name,
        c.last_name,
        sp.duration_in_months,
        cs.subscription_id,
        cs.subscription_start,
        cs.subscription_end,
        julianday(cs.subscription_end) - julianday('now') as days_remaining
      FROM CURRENT_SUBSCRIPTION cs
      JOIN CLIENT c ON cs.client_id = c.client_id
      JOIN SUBSCRIPTION_PLAN sp ON cs.plan_id = sp.plan_id
      WHERE cs.subscription_status = 'Active' 
        AND julianday(cs.subscription_end) - julianday('now') <= 7
        AND julianday(cs.subscription_end) - julianday('now') > 0
      ORDER BY days_remaining
    ''');
  }
}