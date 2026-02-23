import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'gym_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create all tables according to your data dictionary
  Future<void> _onCreate(Database db, int version) async {
    // 1️⃣ PLAN_TYPE table
    await db.execute('''
      CREATE TABLE PLAN_TYPE(
        plan_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_type_name TEXT NOT NULL
      )
    ''');

    // 2️⃣ SUBSCRIPTION_PLAN table
    await db.execute('''
      CREATE TABLE SUBSCRIPTION_PLAN(
        plan_id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_type_id INTEGER NOT NULL,
        duration_in_months INTEGER NOT NULL,
        is_currently_offered INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (plan_type_id) REFERENCES PLAN_TYPE(plan_type_id) ON DELETE CASCADE
      )
    ''');

    // 3️⃣ CLIENT table
    await db.execute('''
      CREATE TABLE CLIENT(
        client_id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        height_cm REAL,
        current_weight_kg REAL,
        gender TEXT CHECK(gender IN ('Male', 'Female', 'Other')),
        date_of_birth TEXT,
        contact_number TEXT NOT NULL,
        email TEXT NOT NULL,
        emergency_contact TEXT NOT NULL,
        medical_notes TEXT,
        date_registered TEXT NOT NULL
      )
    ''');

    // 4️⃣ CURRENT_SUBSCRIPTION table
    await db.execute('''
      CREATE TABLE CURRENT_SUBSCRIPTION(
        subscription_id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        plan_id INTEGER NOT NULL,
        subscription_start TEXT NOT NULL,
        subscription_end TEXT NOT NULL,
        subscription_status TEXT CHECK(subscription_status IN ('Active', 'Expired', 'Paused')) NOT NULL,
        FOREIGN KEY (client_id) REFERENCES CLIENT(client_id) ON DELETE CASCADE,
        FOREIGN KEY (plan_id) REFERENCES SUBSCRIPTION_PLAN(plan_id) ON DELETE CASCADE
      )
    ''');

    // 5️⃣ ATTENDANCE table
    await db.execute('''
      CREATE TABLE ATTENDANCE(
        attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        attendance_date TEXT NOT NULL,
        check_in_time TEXT,
        check_out_time TEXT,
        FOREIGN KEY (client_id) REFERENCES CLIENT(client_id) ON DELETE CASCADE
      )
    ''');

    // 6️⃣ GOAL table
    await db.execute('''
      CREATE TABLE GOAL(
        goal_id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal_name TEXT NOT NULL,
        goal_description TEXT NOT NULL
      )
    ''');

    // 7️⃣ CLIENT_GOAL table
    await db.execute('''
      CREATE TABLE CLIENT_GOAL(
        client_goal_id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        goal_id INTEGER NOT NULL,
        target_days_per_week INTEGER NOT NULL,
        client_goal_start_date TEXT NOT NULL,
        client_goal_status TEXT CHECK(client_goal_status IN ('Ongoing', 'Completed', 'Cancelled')) NOT NULL,
        FOREIGN KEY (client_id) REFERENCES CLIENT(client_id) ON DELETE CASCADE,
        FOREIGN KEY (goal_id) REFERENCES GOAL(goal_id) ON DELETE CASCADE
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insert PLAN_TYPE
    await db.insert('PLAN_TYPE', {'plan_type_name': 'Monthly'});
    await db.insert('PLAN_TYPE', {'plan_type_name': 'Quarterly'});
    await db.insert('PLAN_TYPE', {'plan_type_name': 'Annual'});
    await db.insert('PLAN_TYPE', {'plan_type_name': 'Per Session'});
    await db.insert('PLAN_TYPE', {'plan_type_name': 'Promo'});

    // Insert GOAL
    await db.insert('GOAL', {
      'goal_name': 'Weight Loss',
      'goal_description': 'Reduce body weight and achieve healthy BMI'
    });
    await db.insert('GOAL', {
      'goal_name': 'Muscle Gain',
      'goal_description': 'Increase muscle mass and strength'
    });
    await db.insert('GOAL', {
      'goal_name': 'Endurance',
      'goal_description': 'Improve cardiovascular endurance and stamina'
    });
    await db.insert('GOAL', {
      'goal_name': 'Flexibility',
      'goal_description': 'Enhance flexibility and mobility'
    });
    await db.insert('GOAL', {
      'goal_name': 'General Fitness',
      'goal_description': 'Maintain overall health and fitness'
    });

    // Insert SUBSCRIPTION_PLAN
    // Get plan_type_ids first
    List<Map<String, dynamic>> planTypes = await db.query('PLAN_TYPE');
    
    int monthlyId = planTypes.firstWhere((pt) => pt['plan_type_name'] == 'Monthly')['plan_type_id'];
    int quarterlyId = planTypes.firstWhere((pt) => pt['plan_type_name'] == 'Quarterly')['plan_type_id'];
    int annualId = planTypes.firstWhere((pt) => pt['plan_type_name'] == 'Annual')['plan_type_id'];
    int perSessionId = planTypes.firstWhere((pt) => pt['plan_type_name'] == 'Per Session')['plan_type_id'];

    await db.insert('SUBSCRIPTION_PLAN', {
      'plan_type_id': monthlyId,
      'duration_in_months': 1,
      'is_currently_offered': 1
    });
    await db.insert('SUBSCRIPTION_PLAN', {
      'plan_type_id': quarterlyId,
      'duration_in_months': 3,
      'is_currently_offered': 1
    });
    await db.insert('SUBSCRIPTION_PLAN', {
      'plan_type_id': annualId,
      'duration_in_months': 12,
      'is_currently_offered': 1
    });
    await db.insert('SUBSCRIPTION_PLAN', {
      'plan_type_id': perSessionId,
      'duration_in_months': 0,
      'is_currently_offered': 1
    });
  }

  // Helper method to close database
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}