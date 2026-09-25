import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/widgets/navigation_rail.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/attendance.dart';
import 'package:flutter_application_try_0/models/goal.dart';
import 'package:flutter_application_try_0/models/subscription.dart';
import 'package:flutter_application_try_0/screens/clients_screen.dart';
import 'package:flutter_application_try_0/screens/goals_screen.dart';
import 'package:flutter_application_try_0/screens/subscriptions_screen.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onNavigationItemSelected,
              backgroundColor: AppColors.white,
              indicatorColor: AppColors.yellow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Iconsax.home),
                  selectedIcon: Icon(Iconsax.home_15, color: AppColors.black),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.people),
                  selectedIcon: Icon(Iconsax.people5, color: AppColors.black),
                  label: 'Clients',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.activity),
                  selectedIcon: Icon(Iconsax.activity5, color: AppColors.black),
                  label: 'Goals',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.ticket),
                  selectedIcon: Icon(Iconsax.ticket, color: AppColors.black),
                  label: 'Plans',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.logout),
                  selectedIcon: Icon(Iconsax.logout, color: Colors.red),
                  label: 'Logout',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // Navigation Rail (Desktop / Tablet only)
          if (!isMobile)
            CustomNavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onNavigationItemSelected,
            ),
          
          // Main Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const ClientsScreen();
      case 2:
        return const GoalsScreen();
      case 3:
        return const SubscriptionsScreen(); 
      case 4:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLogoutDialog();
        });
        return _buildDashboard();
      default:
        return _buildDashboard();
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============= DASHBOARD CONTENT WITH CHARTS =============

  Widget _buildDashboard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      color: AppColors.grey,
      child: Column(
        children: [
          // Custom App Bar
          _buildAppBar(),
          
          // Dashboard Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Summary Cards
                  _buildKPICards(),
                  
                  SizedBox(height: isMobile ? 20 : 32),
                  
                  // Charts Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return Column(
                          children: [
                            _buildAttendanceChart(),
                            const SizedBox(height: 20),
                            _buildGoalParticipationChart(),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildAttendanceChart(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: _buildGoalParticipationChart(),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  
                  SizedBox(height: isMobile ? 20 : 32),
                  
                  // Recent Activity and Expiring Soon
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return Column(
                          children: [
                            _buildRecentCheckIns(),
                            const SizedBox(height: 20),
                            _buildExpiringSoon(),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildRecentCheckIns(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: _buildExpiringSoon(),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 12 : 16),
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back, Staff',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Dashboard',
                  style: isMobile ? AppTextStyles.heading3 : AppTextStyles.heading2,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12, vertical: isMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColors.lightYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.calendar, color: AppColors.black, size: isMobile ? 16 : 20),
                const SizedBox(width: 6),
                Text(
                  DateFormat(isMobile ? 'MMM d, y' : 'EEEE, MMMM d, y').format(DateTime.now()),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============= KPI SUMMARY CARDS =============

  Widget _buildKPICards() {
    // Calculate metrics
    int totalActiveMembers = sampleSubscriptions.where((s) => s.status == 'Active').length;
    int totalAttendanceToday = sampleAttendance.where((a) => 
        a.attendanceDate.year == DateTime.now().year &&
        a.attendanceDate.month == DateTime.now().month &&
        a.attendanceDate.day == DateTime.now().day).length;
    int totalExpiredMembers = sampleSubscriptions.where((s) => s.status == 'Expired').length;
    int totalPausedMembers = sampleSubscriptions.where((s) => s.status == 'Paused').length;
    int upcomingExpiries = sampleSubscriptions.where((s) => s.isExpiringSoon).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        double childAspectRatio = 1.45;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 2;
          childAspectRatio = 1.25;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 3;
          childAspectRatio = 1.35;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: [
            _buildKPICard(
              'Active Members',
              totalActiveMembers.toString(),
              Iconsax.people,
              Colors.green,
              'Subscribed',
            ),
            _buildKPICard(
              'Attendance Today',
              totalAttendanceToday.toString(),
              Iconsax.calendar_tick,
              AppColors.yellow,
              'Checked in',
            ),
            _buildKPICard(
              'Expired Members',
              totalExpiredMembers.toString(),
              Iconsax.close_circle,
              Colors.red,
              'Need renewal',
            ),
            _buildKPICard(
              'Paused Members',
              totalPausedMembers.toString(),
              Iconsax.pause,
              Colors.orange,
              'On hold',
            ),
            _buildKPICard(
              'Upcoming Expiries',
              upcomingExpiries.toString(),
              Iconsax.warning_2,
              Colors.blue,
              'Within 7 days',
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppTextStyles.smallText.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ============= ATTENDANCE CHART (LINE CHART) =============

  Widget _buildAttendanceChart() {
    // Generate last 7 days attendance data
    List<Map<String, dynamic>> weeklyData = [];
    for (int i = 6; i >= 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      int count = sampleAttendance.where((a) => 
          a.attendanceDate.year == date.year &&
          a.attendanceDate.month == date.month &&
          a.attendanceDate.day == date.day).length;
      
      weeklyData.add({
        'day': DateFormat('E').format(date),
        'count': count,
      });
    }

    // Find max count for scaling
    int maxCount = weeklyData.map((d) => d['count'] as int).reduce(max);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Iconsax.chart, color: AppColors.yellow),
              SizedBox(width: 8),
              Text(
                'Weekly Attendance Trend',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Simple line chart representation
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: AttendanceChartPainter(weeklyData, maxCount),
              child: Container(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weeklyData.map((data) {
              return Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['day'],
                    style: AppTextStyles.smallText.copyWith(fontSize: 11),
                  ),
                  Text(
                    '${data['count']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          const SizedBox(height: 8),
          
          Center(
            child: Text(
              maxCount == 0 ? 'No attendance data' : 'Peak: $maxCount check-ins',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  // ============= GOAL PARTICIPATION CHART (PIE CHART) =============

  Widget _buildGoalParticipationChart() {
    // Count clients per goal
    Map<int, int> goalCounts = {};
    for (var clientGoal in sampleClientGoals) {
      if (clientGoal.status == 'Ongoing') {
        goalCounts[clientGoal.goalId] = (goalCounts[clientGoal.goalId] ?? 0) + 1;
      }
    }

    // Prepare data for display
    List<Map<String, dynamic>> goalData = [];
    int totalGoals = goalCounts.values.fold(0, (sum, count) => sum + count);
    
    for (var entry in goalCounts.entries) {
      Goal goal = sampleGoals.firstWhere((g) => g.id == entry.key);
      double percentage = totalGoals > 0 ? (entry.value / totalGoals) * 100 : 0;
      goalData.add({
        'name': goal.goalName,
        'count': entry.value,
        'percentage': percentage,
        'color': _getGoalColor(entry.key),
      });
    }

    // Sort by count descending
    goalData.sort((a, b) => b['count'].compareTo(a['count']));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Iconsax.chart, color: AppColors.yellow), // Changed from chart_pie to chart
              SizedBox(width: 8),
              Text(
                'Goal Participation',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Simple pie chart representation
          Row(
            children: [
              // Pie chart circles
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 120,
                  child: CustomPaint(
                    painter: GoalPieChartPainter(goalData, totalGoals),
                    child: Center(
                      child: Text(
                        totalGoals > 0 ? '$totalGoals' : '0',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Legend
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: goalData.take(4).map((data) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: data['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              data['name'],
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${data['percentage'].toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          
          if (goalData.length > 4)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '+${goalData.length - 4} more goals',
                style: AppTextStyles.smallText,
              ),
            ),
        ],
      ),
    );
  }

  Color _getGoalColor(int goalId) {
    List<Color> colors = [
      AppColors.yellow,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    return colors[goalId % colors.length];
  }

  // ============= RECENT CHECK-INS =============

  Widget _buildRecentCheckIns() {
    // Get today's check-ins
    List<Attendance> todayCheckIns = sampleAttendance.where((a) => 
        a.attendanceDate.year == DateTime.now().year &&
        a.attendanceDate.month == DateTime.now().month &&
        a.attendanceDate.day == DateTime.now().day).toList();
    
    // Sort by check-in time (most recent first)
    todayCheckIns.sort((a, b) {
      if (a.checkInTime == null) return 1;
      if (b.checkInTime == null) return -1;
      return b.checkInTime!.compareTo(a.checkInTime!);
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Iconsax.clock, color: AppColors.yellow),
              SizedBox(width: 8),
              Text(
                'Recent Check-ins',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (todayCheckIns.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No check-ins today'),
              ),
            )
          else
            ...List.generate(
              todayCheckIns.length > 5 ? 5 : todayCheckIns.length,
              (index) => _buildCheckInTile(todayCheckIns[index]),
            ),
          
          if (todayCheckIns.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to clients screen with attendance filter
                    setState(() {
                      _selectedIndex = 1; // Clients tab
                    });
                  },
                  child: Text('View all ${todayCheckIns.length} check-ins'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckInTile(Attendance attendance) {
    final client = sampleClients.firstWhere(
      (c) => c.id == attendance.clientId,
      orElse: () => sampleClients.first,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.yellow.withValues(alpha: 0.2),
            child: Text(
              client.firstName[0],
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  attendance.checkInTime != null 
                      ? 'Checked in at ${DateFormat('hh:mm a').format(attendance.checkInTime!)}'
                      : 'Not checked in',
                  style: AppTextStyles.smallText,
                ),
              ],
            ),
          ),
          if (attendance.isCheckedOut)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (attendance.isCheckedIn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============= EXPIRING SOON =============

  Widget _buildExpiringSoon() {
    List<ClientSubscription> expiringSubs = sampleSubscriptions
        .where((s) => s.isExpiringSoon)
        .toList();
    
    // Sort by days remaining (ascending)
    expiringSubs.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Iconsax.warning_2, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Expiring Soon',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (expiringSubs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No expiring subscriptions'),
              ),
            )
          else
            ...List.generate(
              expiringSubs.length > 5 ? 5 : expiringSubs.length,
              (index) => _buildExpiringTile(expiringSubs[index]),
            ),
          
          if (expiringSubs.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3; // Subscriptions tab
                    });
                  },
                  child: Text('View all ${expiringSubs.length} expiring'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpiringTile(ClientSubscription subscription) {
    final client = sampleClients.firstWhere(
      (c) => c.id == subscription.clientId,
      orElse: () => sampleClients.first,
    );
    final plan = samplePlans.firstWhere(
      (p) => p.id == subscription.planId,
      orElse: () => samplePlans.first,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: subscription.daysRemaining <= 3 
              ? Colors.red.withValues(alpha: 0.3) 
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.yellow.withValues(alpha: 0.2),
            child: Text(
              client.firstName[0],
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${plan.planName} • ${subscription.daysRemaining} days left',
                  style: AppTextStyles.smallText.copyWith(
                    color: subscription.daysRemaining <= 3 
                        ? Colors.red 
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: subscription.daysRemaining <= 3 
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${subscription.daysRemaining}d',
              style: TextStyle(
                color: subscription.daysRemaining <= 3 
                    ? Colors.red 
                    : Colors.orange,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= CUSTOM PAINTERS FOR CHARTS =============

class AttendanceChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int maxCount;

  AttendanceChartPainter(this.data, this.maxCount);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxCount == 0) return;

    double width = size.width;
    double height = size.height;
    double padding = 20;
    double graphWidth = width - (padding * 2);
    double graphHeight = height - (padding * 2);
    
    double pointWidth = graphWidth / (data.length - 1);
    
    Paint linePaint = Paint()
      ..color = AppColors.yellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    Paint fillPaint = Paint()
      ..color = AppColors.yellow.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    Paint pointPaint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.fill;
    
    // Create path for line
    Path linePath = Path();
    Path fillPath = Path();
    
    for (int i = 0; i < data.length; i++) {
      double x = padding + (i * pointWidth);
      double y = padding + graphHeight - ((data[i]['count'] / maxCount) * graphHeight);
      
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    // Complete fill path
    fillPath.lineTo(padding + ((data.length - 1) * pointWidth), padding + graphHeight);
    fillPath.lineTo(padding, padding + graphHeight);
    fillPath.close();
    
    // Draw fill
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    canvas.drawPath(linePath, linePaint);
    
    // Draw points
    for (int i = 0; i < data.length; i++) {
      double x = padding + (i * pointWidth);
      double y = padding + graphHeight - ((data[i]['count'] / maxCount) * graphHeight);
      
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = AppColors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GoalPieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int total;

  GoalPieChartPainter(this.data, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || total == 0) return;

    double radius = size.width / 2.5;
    Offset center = Offset(size.width / 2, size.height / 2);
    
    double startAngle = -pi / 2;
    
    for (int i = 0; i < data.length; i++) {
      double sweepAngle = 2 * pi * (data[i]['count'] / total);
      
      Paint paint = Paint()
        ..color = data[i]['color']
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
    
    // Draw inner circle for donut effect
    Paint innerPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}