import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Goal {
  final int goalId;
  final String goalName;
  final String goalDescription;

  Goal({
    required this.goalId,
    required this.goalName,
    required this.goalDescription,
  });

  IconData get icon {
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
      goalId: map['goal_id'],
      goalName: map['goal_name'],
      goalDescription: map['goal_description'],
    );
  }
}

class ClientGoal {
  final int clientGoalId;
  final int clientId;
  final int goalId;
  final int targetDaysPerWeek;
  final DateTime startDate;
  final String status; // 'Ongoing', 'Completed', 'Cancelled'

  ClientGoal({
    required this.clientGoalId,
    required this.clientId,
    required this.goalId,
    required this.targetDaysPerWeek,
    required this.startDate,
    required this.status,
  });

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
      clientGoalId: map['client_goal_id'],
      clientId: map['client_id'],
      goalId: map['goal_id'],
      targetDaysPerWeek: map['target_days_per_week'],
      startDate: DateTime.parse(map['client_goal_start_date']),
      status: map['client_goal_status'],
    );
  }
}