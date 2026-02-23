import 'package:flutter_application_try_0/database/dao/client_dao.dart';
import 'package:flutter_application_try_0/database/dao/attendance_dao.dart';
import 'package:flutter_application_try_0/database/dao/subscription_dao.dart';
import 'package:flutter_application_try_0/database/dao/goal_dao.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/attendance.dart';
import 'package:flutter_application_try_0/models/goal.dart';
import 'package:flutter_application_try_0/models/subscription.dart';

class GymRepository {
  final ClientDao _clientDao = ClientDao();
  final AttendanceDao _attendanceDao = AttendanceDao();
  final SubscriptionDao _subscriptionDao = SubscriptionDao();
  final GoalDao _goalDao = GoalDao();

  // ============= CLIENT OPERATIONS =============
  Future<int> addClient(Client client) => _clientDao.insertClient(client);
  Future<List<Client>> getAllClients() => _clientDao.getAllClients();
  Future<Client?> getClient(int clientId) => _clientDao.getClient(clientId);
  Future<int> updateClient(Client client) => _clientDao.updateClient(client);
  Future<int> deleteClient(int clientId) => _clientDao.deleteClient(clientId);
  Future<List<Client>> searchClients(String query) => _clientDao.searchClients(query);
  Future<int> getClientCount() => _clientDao.getClientCount();

  // ============= ATTENDANCE OPERATIONS =============
  Future<int> checkIn(int clientId) => _attendanceDao.checkIn(clientId);
  Future<int> checkOut(int attendanceId) => _attendanceDao.checkOut(attendanceId);
  Future<List<Attendance>> getTodayAttendance() => _attendanceDao.getTodayAttendance();
  Future<Attendance?> getLastAttendance(int clientId) => _attendanceDao.getLastAttendance(clientId);
  Future<List<Attendance>> getClientAttendance(int clientId) => _attendanceDao.getClientAttendance(clientId);
  Future<Map<String, int>> getWeeklyAttendance() => _attendanceDao.getWeeklyAttendance();
  Future<int> getTodayCheckInCount() => _attendanceDao.getTodayCheckInCount();
  Future<Attendance?> findActiveCheckIn(int clientId) => _attendanceDao.findActiveCheckIn(clientId);

  // ============= SUBSCRIPTION OPERATIONS =============
  Future<List<SubscriptionPlan>> getAllPlans() => _subscriptionDao.getAllPlans();
  Future<List<SubscriptionPlan>> getActivePlans() => _subscriptionDao.getActivePlans();
  Future<int> createSubscription(ClientSubscription subscription) => _subscriptionDao.createSubscription(subscription);
  Future<ClientSubscription?> getClientSubscription(int clientId) => _subscriptionDao.getClientSubscription(clientId);
  Future<int> updateSubscriptionStatus(int subscriptionId, String status) => _subscriptionDao.updateSubscriptionStatus(subscriptionId, status);
  Future<Map<String, int>> getSubscriptionStats() => _subscriptionDao.getSubscriptionStats();
  Future<List<Map<String, dynamic>>> getExpiringSoonDetails() => _subscriptionDao.getExpiringSoonDetails();

  // ============= GOAL OPERATIONS =============
  Future<List<Goal>> getAllGoals() => _goalDao.getAllGoals();
  Future<int> createGoal(Goal goal) => _goalDao.createGoal(goal);
  Future<int> assignGoalToClient(ClientGoal clientGoal) => _goalDao.assignGoalToClient(clientGoal);
  Future<List<ClientGoal>> getClientGoals(int clientId) => _goalDao.getClientGoals(clientId);
  Future<List<Map<String, dynamic>>> getClientsByGoal(int goalId) => _goalDao.getClientsByGoal(goalId);
  Future<int> updateGoalStatus(int clientGoalId, String status) => _goalDao.updateGoalStatus(clientGoalId, status);
  Future<Map<String, int>> getGoalStats() => _goalDao.getGoalStats();
  Future<int> getOngoingGoalsCount() => _goalDao.getOngoingGoalsCount();
}