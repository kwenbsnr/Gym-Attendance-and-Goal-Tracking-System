// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/goal.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey,
      child: Column(
        children: [
          // Custom App Bar
          _buildAppBar(),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Add Goal Button
                  _buildHeader(),
                  
                  const SizedBox(height: 24),
                  
                  // Goal Categories Grid
                  _buildGoalCategoriesGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    int activeGoals = sampleClientGoals.where((g) => g.status == 'Ongoing').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.white,
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Goal Tracking',
                style: AppTextStyles.heading2,
              ),
              Text(
                'Monitor client fitness goals',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.activity, color: AppColors.black),
                const SizedBox(width: 8),
                Text(
                  '$activeGoals Active Goals',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Add Goal Button
        ElevatedButton.icon(
          onPressed: () => _showAddGoalDialog(),
          icon: const Icon(Iconsax.add),
          label: const Text('Add Goal'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  // ============= GOAL CATEGORIES GRID (CARD FORMAT) =============

  Widget _buildGoalCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: sampleGoals.length,
      itemBuilder: (context, index) {
        return _buildGoalCategoryCard(sampleGoals[index]);
      },
    );
  }

  Widget _buildGoalCategoryCard(Goal goal) {
    // Count clients with this goal
    List<ClientGoal> goalClients = sampleClientGoals
        .where((cg) => cg.goalId == goal.id)
        .toList();
    
    int activeCount = goalClients.where((cg) => cg.status == 'Ongoing').length;

    return GestureDetector(
      onTap: () => _showGoalDetails(goal),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.withOpacity(AppColors.yellow, 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      goal.icon ?? Iconsax.activity,
                      color: AppColors.yellow,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.goalName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$activeCount active • ${goalClients.length} total',
                          style: AppTextStyles.smallText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.goalDescription,
                    style: AppTextStyles.smallText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Preview of clients with this goal
                  if (goalClients.isNotEmpty)
                    ...List.generate(
                      goalClients.length > 2 ? 2 : goalClients.length,
                      (index) {
                        final clientGoal = goalClients[index];
                        final client = sampleClients.firstWhere(
                          (c) => c.id == clientGoal.clientId,
                          orElse: () => sampleClients.first,
                        );
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.withOpacity(AppColors.yellow, 0.2),
                                child: Text(
                                  client.firstName[0],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  client.fullName,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: clientGoal.status == 'Ongoing'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${clientGoal.targetDaysPerWeek}/week',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: clientGoal.status == 'Ongoing'
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  
                  if (goalClients.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${goalClients.length - 2} more clients',
                        style: AppTextStyles.smallText.copyWith(fontSize: 11),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============= GOAL DETAILS DIALOG =============

  void _showGoalDetails(Goal goal) {
    List<ClientGoal> goalClients = sampleClientGoals
        .where((cg) => cg.goalId == goal.id)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(goal.goalName),
          content: Container(
            width: 600,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.goalDescription,
                  style: const TextStyle(fontSize: 14),
                ),
                
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                const Text(
                  'Clients with this goal:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                if (goalClients.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No clients with this goal'),
                    ),
                  )
                else
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: goalClients.length,
                      itemBuilder: (context, index) {
                        final clientGoal = goalClients[index];
                        final client = sampleClients.firstWhere(
                          (c) => c.id == clientGoal.clientId,
                          orElse: () => sampleClients.first,
                        );
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.withOpacity(AppColors.yellow, 0.2),
                              child: Text(client.firstName[0]),
                            ),
                            title: Text(client.fullName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Target: ${clientGoal.targetDaysPerWeek} days/week'),
                                Text('Start: ${DateFormat('MMM d, y').format(clientGoal.startDate)}'),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: clientGoal.status == 'Ongoing'
                                    ? Colors.green.withOpacity(0.1)
                                    : (clientGoal.status == 'Completed'
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                clientGoal.status,
                                style: TextStyle(
                                  color: clientGoal.status == 'Ongoing'
                                      ? Colors.green
                                      : (clientGoal.status == 'Completed'
                                          ? Colors.blue
                                          : Colors.red),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddGoalDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Goal Category'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Name',
                    prefixIcon: Icon(Iconsax.activity, size: 18),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Iconsax.note, size: 18),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goal category added successfully'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Add Goal'),
            ),
          ],
        );
      },
    );
  }
}