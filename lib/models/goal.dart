import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Goal {
  final int id;
  final String goalName;
  final String goalDescription;
  final IconData? icon;

  Goal({
    required this.id,
    required this.goalName,
    required this.goalDescription,
    this.icon,
  });
}

class ClientGoal {
  final int id;
  final int clientId;
  final int goalId;
  final int targetDaysPerWeek;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // 'Active', 'Completed', 'Paused', 'Abandoned'
  final double? targetValue;
  final double? currentValue;
  final String? unit; // 'kg', 'reps', 'minutes', etc.

  ClientGoal({
    required this.id,
    required this.clientId,
    required this.goalId,
    required this.targetDaysPerWeek,
    required this.startDate,
    this.endDate,
    required this.status,
    this.targetValue,
    this.currentValue,
    this.unit,
  });

  double get progress {
    if (targetValue == null || currentValue == null) return 0;
    return (currentValue! / targetValue!).clamp(0.0, 1.0);
  }

  int get daysRemaining {
    if (endDate == null) return 0;
    return endDate!.difference(DateTime.now()).inDays.clamp(0, 9999);
  }

  String get formattedProgress {
    if (targetValue == null || currentValue == null) return '--';
    return '${(progress * 100).toStringAsFixed(0)}%';
  }
}

// Sample Goals Data
List<Goal> sampleGoals = [
  Goal(
    id: 1,
    goalName: 'Weight Loss',
    goalDescription: 'Reduce body weight to target',
    icon: Iconsax.weight,
  ),
  Goal(
    id: 2,
    goalName: 'Muscle Gain',
    goalDescription: 'Increase muscle mass',
    icon: Iconsax.man,
  ),
  Goal(
    id: 3,
    goalName: 'Strength Training',
    goalDescription: 'Improve overall strength',
    icon: Iconsax.chart,
  ),
  Goal(
    id: 4,
    goalName: 'Cardio Endurance',
    goalDescription: 'Improve cardiovascular fitness',
    icon: Iconsax.heart,
  ),
  Goal(
    id: 5,
    goalName: 'Flexibility',
    goalDescription: 'Improve flexibility and mobility',
    icon: Iconsax.ruler,
  ),
];

// Sample Client Goals
List<ClientGoal> sampleClientGoals = [
  ClientGoal(
    id: 1,
    clientId: 1, // John Doe
    goalId: 1,
    targetDaysPerWeek: 4,
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now().add(const Duration(days: 60)),
    status: 'Active',
    targetValue: 70,
    currentValue: 75,
    unit: 'kg',
  ),
  ClientGoal(
    id: 2,
    clientId: 1, // John Doe
    goalId: 3,
    targetDaysPerWeek: 3,
    startDate: DateTime.now().subtract(const Duration(days: 15)),
    endDate: DateTime.now().add(const Duration(days: 45)),
    status: 'Active',
    targetValue: 100,
    currentValue: 80,
    unit: 'kg bench press',
  ),
  ClientGoal(
    id: 3,
    clientId: 2, // Sarah Smith
    goalId: 2,
    targetDaysPerWeek: 5,
    startDate: DateTime.now().subtract(const Duration(days: 45)),
    endDate: DateTime.now().add(const Duration(days: 15)),
    status: 'Active',
    targetValue: 65,
    currentValue: 62,
    unit: 'kg',
  ),
  ClientGoal(
    id: 4,
    clientId: 2, // Sarah Smith
    goalId: 4,
    targetDaysPerWeek: 3,
    startDate: DateTime.now().subtract(const Duration(days: 60)),
    endDate: DateTime.now().subtract(const Duration(days: 5)),
    status: 'Completed',
    targetValue: 30,
    currentValue: 30,
    unit: 'min run',
  ),
  ClientGoal(
    id: 5,
    clientId: 3, // Mike Johnson
    goalId: 5,
    targetDaysPerWeek: 2,
    startDate: DateTime.now().subtract(const Duration(days: 10)),
    endDate: DateTime.now().add(const Duration(days: 80)),
    status: 'Active',
    targetValue: 20,
    currentValue: 10,
    unit: 'cm reach',
  ),
];