import 'package:flutter/material.dart';
import 'package:flutter_application_try_0/repositories/client_repository.dart';
import 'package:flutter_application_try_0/models/client.dart';

class DatabaseProvider extends ChangeNotifier {
  final ClientRepository _repository = ClientRepository();
  
  List<Client> _clients = [];
  List<Client> get clients => _clients;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _error = '';
  String get error => _error;

  // Load all clients
  Future<void> loadClients() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _clients = await _repository.getAllClients();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new client
  Future<bool> addClient(Client client) async {
    try {
      await _repository.addClient(client);
      await loadClients(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update client
  Future<bool> updateClient(Client client) async {
    try {
      await _repository.updateClient(client);
      await loadClients(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete client
  Future<bool> deleteClient(int id) async {
    try {
      await _repository.deleteClient(id);
      await loadClients(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Search clients
  Future<void> searchClients(String query) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _clients = await _repository.searchClients(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}