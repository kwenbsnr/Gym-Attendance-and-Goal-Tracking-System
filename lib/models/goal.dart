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
  final String status; // 'Ongoing', 'Completed', 'Cancelled'

  ClientGoal({
    required this.id,
    required this.clientId,
    required this.goalId,
    required this.targetDaysPerWeek,
    required this.startDate,
    this.endDate,
    required this.status,
  });

  int get daysRemaining {
    if (endDate == null) return 0;
    return endDate!.difference(DateTime.now()).inDays.clamp(0, 9999);
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