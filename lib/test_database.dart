import 'package:flutter/material.dart';
import 'package:flutter_application_try_0/repositories/gym_repository.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/goal.dart';

class TestDatabaseScreen extends StatefulWidget {
  const TestDatabaseScreen({super.key});

  @override
  State<TestDatabaseScreen> createState() => _TestDatabaseScreenState();
}

class _TestDatabaseScreenState extends State<TestDatabaseScreen> {
  final GymRepository _repo = GymRepository();
  String _result = 'Ready to test';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_result),
                ),
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _testClientOperations,
                  child: const Text('Test Client'),
                ),
                ElevatedButton(
                  onPressed: _testSubscriptionOperations,
                  child: const Text('Test Subscription'),
                ),
                ElevatedButton(
                  onPressed: _testGoalOperations,
                  child: const Text('Test Goal'),
                ),
                ElevatedButton(
                  onPressed: _testAttendanceOperations,
                  child: const Text('Test Attendance'),
                ),
                ElevatedButton(
                  onPressed: _testAll,
                  child: const Text('Test All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testClientOperations() async {
    _setLoading(true);
    try {
      StringBuffer sb = StringBuffer();
      sb.writeln('=== CLIENT OPERATIONS ===\n');
      
      // Count before
      int beforeCount = await _repo.getClientCount();
      sb.writeln('Clients before: $beforeCount');
      
      // Add a client
      Client newClient = Client(
        clientId: 0, // Will be auto-generated
        firstName: 'John',
        lastName: 'Doe',
        heightCm: 175.0,
        currentWeightKg: 75.0,
        gender: 'Male',
        dateOfBirth: DateTime(1990, 5, 15),
        contactNumber: '123-456-7890',
        email: 'john@email.com',
        emergencyContact: 'Jane: 098-765-4321',
        medicalNotes: 'None',
        dateRegistered: DateTime.now(),
      );
      
      int id = await _repo.addClient(newClient);
      sb.writeln('Added client with ID: $id');
      
      // Get all clients
      List<Client> clients = await _repo.getAllClients();
      sb.writeln('All clients (${clients.length}):');
      for (var c in clients) {
        sb.writeln('  - ${c.fullName} (ID: ${c.clientId})');
      }
      
      // Search
      List<Client> search = await _repo.searchClients('john');
      sb.writeln('Search "john" found: ${search.length}');
      
      _setResult(sb.toString());
    } catch (e) {
      _setResult('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _testSubscriptionOperations() async {
    _setLoading(true);
    try {
      StringBuffer sb = StringBuffer();
      sb.writeln('=== SUBSCRIPTION OPERATIONS ===\n');
      
      // Get stats
      var stats = await _repo.getSubscriptionStats();
      sb.writeln('Subscription Stats:');
      sb.writeln('  Active: ${stats['active']}');
      sb.writeln('  Expired: ${stats['expired']}');
      sb.writeln('  Paused: ${stats['paused']}');
      sb.writeln('  Expiring Soon: ${stats['expiringSoon']}');
      
      // Get expiring soon
      var expiring = await _repo.getExpiringSoonDetails();
      sb.writeln('\nExpiring Soon (${expiring.length}):');
      for (var e in expiring) {
        sb.writeln('  ${e['first_name']} ${e['last_name']}: ${e['days_remaining']} days left');
      }
      
      _setResult(sb.toString());
    } catch (e) {
      _setResult('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _testGoalOperations() async {
    _setLoading(true);
    try {
      StringBuffer sb = StringBuffer();
      sb.writeln('=== GOAL OPERATIONS ===\n');
      
      // Get all goals
      List<Goal> goals = await _repo.getAllGoals();
      sb.writeln('Available Goals (${goals.length}):');
      for (var g in goals) {
        sb.writeln('  - ${g.goalName}: ${g.goalDescription}');
      }
      
      // Get stats
      var stats = await _repo.getGoalStats();
      sb.writeln('\nGoal Participation:');
      stats.forEach((goal, count) {
        sb.writeln('  $goal: $count clients');
      });
      
      _setResult(sb.toString());
    } catch (e) {
      _setResult('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _testAttendanceOperations() async {
    _setLoading(true);
    try {
      StringBuffer sb = StringBuffer();
      sb.writeln('=== ATTENDANCE OPERATIONS ===\n');
      
      // Today's check-ins
      int today = await _repo.getTodayCheckInCount();
      sb.writeln('Today\'s check-ins: $today');
      
      // Weekly data
      var weekly = await _repo.getWeeklyAttendance();
      sb.writeln('\nWeekly Attendance:');
      weekly.forEach((day, count) {
        sb.writeln('  $day: $count');
      });
      
      _setResult(sb.toString());
    } catch (e) {
      _setResult('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _testAll() async {
    await _testClientOperations();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testSubscriptionOperations();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testGoalOperations();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testAttendanceOperations();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _setResult(String result) {
    setState(() {
      _result = result;
    });
  }
}