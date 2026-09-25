import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Goal {
  final int goalId;
  final String goalName;
  final String goalDescription;
  final IconData? customIcon;

  Goal({
    int? id,
    int? goalId,
    required this.goalName,
    required this.goalDescription,
    IconData? icon,
  })  : goalId = goalId ?? id ?? 0,
        customIcon = icon;

  int get id => goalId;

  IconData get icon {
    if (customIcon != null) return customIcon!;
    switch (goalName) {
      case 'Weight Loss':
        return Iconsax.weight;
      case 'Muscle Gain':
        return Iconsax.man;
      case 'Endurance':
        return Iconsax.heart;
      case 'Flexibility':
        return Iconsax.ruler;
      default:
        return Iconsax.activity;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'goal_id': goalId,
      'goal_name': goalName,
      'goal_description': goalDescription,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      goalId: map['goal_id'] ?? map['id'] ?? 0,
      goalName: map['goal_name'] ?? '',
      goalDescription: map['goal_description'] ?? '',
    );
  }
}

class ClientGoal {
  final int clientGoalId;
  final int clientId;
  final int goalId;
  final int targetDaysPerWeek;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // 'Ongoing', 'Completed', 'Cancelled'

  ClientGoal({
    int? id,
    int? clientGoalId,
    required this.clientId,
    required this.goalId,
    required this.targetDaysPerWeek,
    required this.startDate,
    this.endDate,
    required this.status,
  }) : clientGoalId = clientGoalId ?? id ?? 0;

  int get id => clientGoalId;

  int get daysRemaining {
    if (endDate == null) return 0;
    return endDate!.difference(DateTime.now()).inDays.clamp(0, 9999);
  }

  Map<String, dynamic> toMap() {
    return {
      'client_goal_id': clientGoalId,
      'client_id': clientId,
      'goal_id': goalId,
      'target_days_per_week': targetDaysPerWeek,
      'client_goal_start_date': startDate.toIso8601String(),
      'client_goal_status': status,
    };
  }

  factory ClientGoal.fromMap(Map<String, dynamic> map) {
    return ClientGoal(
      clientGoalId: map['client_goal_id'] ?? map['id'] ?? 0,
      clientId: map['client_id'] ?? 0,
      goalId: map['goal_id'] ?? 0,
      targetDaysPerWeek: map['target_days_per_week'] ?? 0,
      startDate: map['client_goal_start_date'] != null
          ? DateTime.parse(map['client_goal_start_date'])
          : (map['start_date'] != null
              ? DateTime.parse(map['start_date'])
              : DateTime.now()),
      status: map['client_goal_status'] ?? map['status'] ?? 'Ongoing',
    );
  }
}

// Sample Goals Data
List<Goal> sampleGoals = [
  Goal(
    id: 1,
    goalName: 'Weight Loss',
    goalDescription: 'Reduce body weight and achieve healthy BMI',
    icon: Iconsax.weight,
  ),
  Goal(
    id: 2,
    goalName: 'Muscle Gain',
    goalDescription: 'Increase muscle mass and strength',
    icon: Iconsax.man,
  ),
  Goal(
    id: 3,
    goalName: 'Endurance',
    goalDescription: 'Improve cardiovascular endurance and stamina',
    icon: Iconsax.heart,
  ),
  Goal(
    id: 4,
    goalName: 'Flexibility',
    goalDescription: 'Enhance flexibility and mobility',
    icon: Iconsax.ruler,
  ),
  Goal(
    id: 5,
    goalName: 'General Fitness',
    goalDescription: 'Maintain overall health and fitness',
    icon: Iconsax.activity,
  ),
];

// Sample Client Goals
List<ClientGoal> sampleClientGoals = [
  ClientGoal(
    id: 1,
    clientId: 1,
    goalId: 1,
    targetDaysPerWeek: 4,
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now().add(const Duration(days: 60)),
    status: 'Ongoing',
  ),
  ClientGoal(
    id: 2,
    clientId: 1,
    goalId: 3,
    targetDaysPerWeek: 3,
    startDate: DateTime.now().subtract(const Duration(days: 15)),
    status: 'Ongoing',
  ),
  ClientGoal(
    id: 3,
    clientId: 2,
    goalId: 2,
    targetDaysPerWeek: 5,
    startDate: DateTime.now().subtract(const Duration(days: 45)),
    endDate: DateTime.now().add(const Duration(days: 15)),
    status: 'Ongoing',
  ),
  ClientGoal(
    id: 4,
    clientId: 2,
    goalId: 4,
    targetDaysPerWeek: 3,
    startDate: DateTime.now().subtract(const Duration(days: 60)),
    endDate: DateTime.now().subtract(const Duration(days: 5)),
    status: 'Completed',
  ),
  ClientGoal(
    id: 5,
    clientId: 3,
    goalId: 5,
    targetDaysPerWeek: 2,
    startDate: DateTime.now().subtract(const Duration(days: 10)),
    status: 'Ongoing',
  ),
  ClientGoal(
    id: 6,
    clientId: 4,
    goalId: 1,
    targetDaysPerWeek: 3,
    startDate: DateTime.now().subtract(const Duration(days: 20)),
    status: 'Ongoing',
  ),
  ClientGoal(
    id: 7,
    clientId: 4,
    goalId: 2,
    targetDaysPerWeek: 2,
    startDate: DateTime.now().subtract(const Duration(days: 20)),
    status: 'Ongoing',
  ),
  ClientGoal(
    id: 8,
    clientId: 5,
    goalId: 3,
    targetDaysPerWeek: 4,
    startDate: DateTime.now().subtract(const Duration(days: 5)),
    status: 'Ongoing',
  ),
];