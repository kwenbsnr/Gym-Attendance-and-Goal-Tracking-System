// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/attendance.dart';
import 'package:flutter_application_try_0/models/subscription.dart';
import 'package:flutter_application_try_0/models/goal.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Active, Paused
  DateTime? _selectedInactiveDate;
  String _selectedView = 'list'; // grid or list
  
  final List<String> _filterOptions = ['All', 'Active', 'Paused', 'Inactive Since'];
  
  // For form fields
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now().subtract(const Duration(days: 6570)); // Default 18 years old
  
  // For subscription assignment
  DateTime _subscriptionStart = DateTime.now();
  
  // For goal assignment
  final List<int> _selectedGoalIds = [];

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
                  // Header with Stats and Actions
                  _buildHeaderSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Cards
                  _buildStatsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Search, Filter and View Toggle
                  _buildSearchFilterBar(),
                  
                  const SizedBox(height: 24),
                  
                  // Clients View (Table format)
                  _buildClientsTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.white,
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Client Management',
                style: AppTextStyles.heading2,
              ),
              Text(
                'Manage members, attendance, and goals',
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
                const Icon(Iconsax.people, color: AppColors.black),
                const SizedBox(width: 8),
                Text(
                  '${sampleClients.length} Total Clients',
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

  Widget _buildHeaderSection() {
    return Row(
      children: [
        // Add New Client Button (Floating style)
        ElevatedButton.icon(
          onPressed: () => _showClientForm(),
          icon: const Icon(Iconsax.user_add),
          label: const Text('Add New Client'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    // Calculate stats
    int totalClients = sampleClients.length;
    int activeToday = sampleAttendance
        .where((a) => 
            a.attendanceDate.year == DateTime.now().year &&
            a.attendanceDate.month == DateTime.now().month &&
            a.attendanceDate.day == DateTime.now().day)
        .length;
    int withActiveSub = sampleSubscriptions.where((s) => s.status == 'Active').length;
    int withGoals = sampleClientGoals.where((g) => g.status == 'Ongoing').length;

    return Row(
      children: [
        _buildStatCard(
          'Total Clients',
          totalClients.toString(),
          Iconsax.people,
          AppColors.yellow,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Active Today',
          activeToday.toString(),
          Iconsax.activity,
          Colors.green,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Active Subs',
          withActiveSub.toString(),
          Iconsax.ticket,
          Colors.blue,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'With Goals',
          withGoals.toString(),
          Iconsax.note,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by first name or last name...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Iconsax.search_normal, size: 20),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Filter Options
          Expanded(
            child: Row(
              children: _filterOptions.map((filter) {
                if (filter == 'Inactive Since') {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedInactiveDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedFilter = filter;
                              _selectedInactiveDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedFilter == filter 
                                ? AppColors.yellow 
                                : AppColors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.calendar,
                                size: 14,
                                color: _selectedFilter == filter 
                                    ? AppColors.black 
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _selectedInactiveDate != null && _selectedFilter == filter
                                      ? DateFormat('MMM d').format(_selectedInactiveDate!)
                                      : filter,
                                  style: TextStyle(
                                    color: _selectedFilter == filter 
                                        ? AppColors.black 
                                        : Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: _selectedFilter == filter 
                                        ? FontWeight.w600 
                                        : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: _selectedFilter == filter 
                              ? AppColors.black 
                              : Colors.grey.shade700,
                          fontSize: 12,
                          fontWeight: _selectedFilter == filter 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                      selected: _selectedFilter == filter,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                          if (filter != 'Inactive Since') {
                            _selectedInactiveDate = null;
                          }
                        });
                      },
                      backgroundColor: AppColors.grey,
                      selectedColor: AppColors.yellow,
                      checkmarkColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // View Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildViewToggleButton(Iconsax.element_3, 'list'),
                _buildViewToggleButton(Iconsax.element_4, 'grid'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(IconData icon, String view) {
    final isSelected = _selectedView == view;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedView = view;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? AppColors.black : Colors.grey,
        ),
      ),
    );
  }

  // ============= CLIENTS TABLE (REQUIRED FORMAT) =============

  Widget _buildClientsTable() {
    // Filter clients based on search and filter
    List<Client> filteredClients = _filterClients();

    if (filteredClients.isEmpty) {
      return _buildEmptyState();
    }

    if (_selectedView == 'list') {
      return _buildTableFormat(filteredClients);
    } else {
      return _buildGridFormat(filteredClients);
    }
  }

  List<Client> _filterClients() {
    return sampleClients.where((client) {
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          client.firstName.toLowerCase().contains(_searchQuery) ||
          client.lastName.toLowerCase().contains(_searchQuery);
      
      if (!matchesSearch) return false;
      
      // Status filter
      ClientSubscription? sub = sampleSubscriptions.firstWhere(
        (s) => s.clientId == client.id,
        orElse: () => ClientSubscription(
          id: 0,
          clientId: client.id,
          planId: 0,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          status: 'Expired',
        ),
      );
      
      if (_selectedFilter == 'Active') {
        return sub.status == 'Active';
      } else if (_selectedFilter == 'Paused') {
        return sub.status == 'Paused';
      } else if (_selectedFilter == 'Inactive Since' && _selectedInactiveDate != null) {
        // Check if last attendance was before selected date
        List<Attendance> clientAttendance = sampleAttendance
            .where((a) => a.clientId == client.id)
            .toList();
        
        if (clientAttendance.isEmpty) return true;
        
        clientAttendance.sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));
        return clientAttendance.first.attendanceDate.isBefore(_selectedInactiveDate!);
      }
      
      return true; // 'All' filter
    }).toList();
  }

  Widget _buildTableFormat(List<Client> clients) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                _buildHeaderCell('Client Name', flex: 2),
                _buildHeaderCell('Last Check-In'),
                _buildHeaderCell('Last Check-Out'),
                _buildHeaderCell('Subscription Status'),
                _buildHeaderCell('Actions', flex: 2),
              ],
            ),
          ),
          
          // Table Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clients.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildTableRow(clients[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, {double flex = 1}) {
    return Expanded(
      flex: flex ~/ 1,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTableRow(Client client) {
    // Get client's attendance
    List<Attendance> clientAttendance = sampleAttendance
        .where((a) => a.clientId == client.id)
        .toList();
    
    clientAttendance.sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));
    
    Attendance? lastAttendance = clientAttendance.isNotEmpty ? clientAttendance.first : null;
    
    // Get subscription status
    ClientSubscription? sub = sampleSubscriptions.firstWhere(
      (s) => s.clientId == client.id,
      orElse: () => ClientSubscription(
        id: 0,
        clientId: client.id,
        planId: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        status: 'Expired',
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Client Name
          Expanded(
            flex: 2,
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
                        client.email,
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Last Check-In
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastAttendance?.formattedCheckInTime ?? 'Not checked in',
                  style: const TextStyle(fontSize: 13),
                ),
                if (lastAttendance != null)
                  Text(
                    DateFormat('MMM d, y').format(lastAttendance.attendanceDate),
                    style: AppTextStyles.smallText.copyWith(fontSize: 11),
                  ),
              ],
            ),
          ),
          
          // Last Check-Out
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastAttendance?.formattedCheckOutTime ?? 'Not checked out',
                  style: const TextStyle(fontSize: 13),
                ),
                if (lastAttendance?.checkOutTime != null)
                  Text(
                    'Duration: ${lastAttendance!.formattedDuration}',
                    style: AppTextStyles.smallText.copyWith(fontSize: 11),
                  ),
              ],
            ),
          ),
          
          // Subscription Status
          Expanded(
            child: _buildStatusChip(sub.status),
          ),
          
          // Actions
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Check In Button
                if (sub.status == 'Active')
                  IconButton(
                    icon: const Icon(Iconsax.login, size: 18),
                    color: Colors.green,
                    onPressed: () => _showCheckInDialog(client),
                    tooltip: 'Check In',
                  ),
                
                // Check Out Button
                if (sub.status == 'Active' && lastAttendance?.isCheckedIn == true && lastAttendance?.isCheckedOut == false)
                  IconButton(
                    icon: const Icon(Iconsax.logout, size: 18),
                    color: Colors.blue,
                    onPressed: () => _showCheckOutDialog(client),
                    tooltip: 'Check Out',
                  ),
                
                // Add Goal Button
                IconButton(
                  icon: const Icon(Iconsax.note_add, size: 18),
                  color: AppColors.yellow,
                  onPressed: () => _showAddGoalDialog(client),
                  tooltip: 'Add Goal',
                ),
                
                // View Goals Button
                IconButton(
                  icon: const Icon(Iconsax.activity, size: 18),
                  color: Colors.orange,
                  onPressed: () => _showViewGoalsDialog(client),
                  tooltip: 'View Goals',
                ),
                
                // View Details Button
                IconButton(
                  icon: const Icon(Iconsax.eye, size: 18),
                  color: Colors.grey,
                  onPressed: () => _showClientDetails(client),
                  tooltip: 'View Details',
                ),
                
                // Edit Button
                IconButton(
                  icon: const Icon(Iconsax.edit, size: 18),
                  color: Colors.blue,
                  onPressed: () => _showClientForm(client: client),
                  tooltip: 'Edit Client',
                ),
                
                // Delete Button
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 18),
                  color: Colors.red,
                  onPressed: () => _showDeleteConfirmation(client),
                  tooltip: 'Delete Client',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridFormat(List<Client> clients) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        return _buildClientCard(clients[index]);
      },
    );
  }

  Widget _buildClientCard(Client client) {
    // Get client's attendance
    List<Attendance> clientAttendance = sampleAttendance
        .where((a) => a.clientId == client.id)
        .toList();
    
    clientAttendance.sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));
    
    Attendance? lastAttendance = clientAttendance.isNotEmpty ? clientAttendance.first : null;
    
    // Get subscription status
    ClientSubscription? sub = sampleSubscriptions.firstWhere(
      (s) => s.clientId == client.id,
      orElse: () => ClientSubscription(
        id: 0,
        clientId: client.id,
        planId: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        status: 'Expired',
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        client.email,
                        style: AppTextStyles.smallText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(sub.status, small: true),
              ],
            ),
          ),
          
          // Card Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Last Check-in Info
                Row(
                  children: [
                    const Icon(Iconsax.login, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lastAttendance?.formattedCheckInTime ?? 'Not checked in',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Iconsax.logout, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lastAttendance?.formattedCheckOutTime ?? 'Not checked out',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (sub.status == 'Active')
                      IconButton(
                        icon: const Icon(Iconsax.login, size: 16),
                        color: Colors.green,
                        onPressed: () => _showCheckInDialog(client),
                        tooltip: 'Check In',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    if (sub.status == 'Active' && lastAttendance?.isCheckedIn == true && lastAttendance?.isCheckedOut == false)
                      IconButton(
                        icon: const Icon(Iconsax.logout, size: 16),
                        color: Colors.blue,
                        onPressed: () => _showCheckOutDialog(client),
                        tooltip: 'Check Out',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    IconButton(
                      icon: const Icon(Iconsax.note_add, size: 16),
                      color: AppColors.yellow,
                      onPressed: () => _showAddGoalDialog(client),
                      tooltip: 'Add Goal',
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.eye, size: 16),
                      color: Colors.grey,
                      onPressed: () => _showClientDetails(client),
                      tooltip: 'View Details',
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    PopupMenuButton(
                      icon: const Icon(Iconsax.more, size: 16),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view_goals',
                          child: Row(
                            children: [
                              Icon(Iconsax.activity, size: 16),
                              SizedBox(width: 8),
                              Text('View Goals'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Iconsax.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Iconsax.trash, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'view_goals') {
                          _showViewGoalsDialog(client);
                        } else if (value == 'edit') {
                          _showClientForm(client: client);
                        } else if (value == 'delete') {
                          _showDeleteConfirmation(client);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: This method now always returns a non-null Color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Expired':
        return Colors.red;
      case 'Paused':
        return Colors.orange;
      default:
        return Colors.grey; // Always return a color, never null
    }
  }

  // FIXED: Added null safety to all color operations
  Widget _buildStatusChip(String status, {bool small = false}) {
    final Color color = _getStatusColor(status); // Now guaranteed non-null
    
    IconData icon;
    switch (status) {
      case 'Active':
        icon = Iconsax.tick_circle;
        break;
      case 'Expired':
        icon = Iconsax.close_circle;
        break;
      case 'Paused':
        icon = Iconsax.pause;
        break;
      default:
        icon = Iconsax.activity;
    }

    if (small) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), // FIXED: using withValues
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 10),
            const SizedBox(width: 2),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), // FIXED: using withValues
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3), // FIXED: using withValues
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.lightYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.people,
                size: 48,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No clients found',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty 
                  ? 'Click "Add New Client" to get started'
                  : 'Try adjusting your search or filter',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  // ============= ATTENDANCE MANAGEMENT =============

  void _showCheckInDialog(Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Check In Client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Check in ${client.fullName}?'),
              const SizedBox(height: 16),
              Text(
                'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
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
                  SnackBar(
                    content: Text('${client.fullName} checked in successfully'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Check In'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckOutDialog(Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Check Out Client'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Check out ${client.fullName}?'),
              const SizedBox(height: 16),
              Text(
                'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
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
                  SnackBar(
                    content: Text('${client.fullName} checked out successfully'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Check Out'),
            ),
          ],
        );
      },
    );
  }

  // ============= GOAL MANAGEMENT =============

  void _showAddGoalDialog(Client client) {
    List<Goal> availableGoals = sampleGoals;
    List<int> tempSelectedGoals = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assign Goal to ${client.fullName}'),
          content: SizedBox(
            width: 400,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Select goals to assign:'),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: availableGoals.length,
                        itemBuilder: (context, index) {
                          final goal = availableGoals[index];
                          return CheckboxListTile(
                            title: Text(goal.goalName),
                            subtitle: Text(goal.goalDescription, maxLines: 1, overflow: TextOverflow.ellipsis),
                            value: tempSelectedGoals.contains(goal.id),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  tempSelectedGoals.add(goal.id);
                                } else {
                                  tempSelectedGoals.remove(goal.id);
                                }
                              });
                            },
                            activeColor: AppColors.yellow,
                            checkColor: AppColors.black,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Target Days Per Week',
                        prefixIcon: Icon(Iconsax.calendar, size: 18),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              },
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
                  SnackBar(
                    content: Text('Goals assigned to ${client.fullName}'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  void _showViewGoalsDialog(Client client) {
    List<ClientGoal> clientGoals = sampleClientGoals
        .where((cg) => cg.clientId == client.id)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${client.fullName}\'s Goals'),
          content: SizedBox(
            width: 400,
            child: clientGoals.isEmpty
                ? const Center(child: Text('No goals assigned'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: clientGoals.length,
                    itemBuilder: (context, index) {
                      final clientGoal = clientGoals[index];
                      final goal = sampleGoals.firstWhere(
                        (g) => g.id == clientGoal.goalId,
                        orElse: () => sampleGoals.first,
                      );
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(goal.icon ?? Iconsax.activity, color: AppColors.yellow),
                          title: Text(goal.goalName),
                          subtitle: Text('${clientGoal.targetDaysPerWeek} days/week • ${clientGoal.status}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: clientGoal.status == 'Ongoing'
                                  ? Colors.green.withValues(alpha: 0.1) // FIXED: using withValues
                                  : (clientGoal.status == 'Completed'
                                      ? Colors.blue.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1)),
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
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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

  // ============= CLIENT CRUD OPERATIONS =============

  void _showClientForm({Client? client}) {
    if (client != null) {
      // Populate form for editing
      _firstNameController.text = client.firstName;
      _lastNameController.text = client.lastName;
      _emailController.text = client.email;
      _phoneController.text = client.contactNumber;
      _heightController.text = client.heightCm.toString();
      _weightController.text = client.currentWeightKg.toString();
      _emergencyContactController.text = client.emergencyContact;
      _medicalNotesController.text = client.medicalNotes ?? '';
      _selectedGender = client.gender;
      _selectedDate = client.dateOfBirth;
    } else {
      // Clear for new client
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _heightController.clear();
      _weightController.clear();
      _emergencyContactController.clear();
      _medicalNotesController.clear();
      _selectedGender = 'Male';
      _selectedDate = DateTime.now().subtract(const Duration(days: 6570));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(client == null ? 'Add New Client' : 'Edit Client'),
          content: Container(
            width: 600,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Personal Information
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name *',
                              prefixIcon: Icon(Iconsax.user, size: 18),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name *',
                              prefixIcon: Icon(Iconsax.user, size: 18),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Gender and DOB
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender, // FIXED: Changed from initialValue to value
                            decoration: const InputDecoration(
                              labelText: 'Gender *',
                              prefixIcon: Icon(Iconsax.man, size: 18),
                            ),
                            items: ['Male', 'Female', 'Other'].map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date of Birth *',
                                prefixIcon: Icon(Iconsax.calendar, size: 18),
                              ),
                              child: Text(
                                DateFormat('MMM d, y').format(_selectedDate),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Contact Information
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact Information',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address *',
                        prefixIcon: Icon(Iconsax.sms, size: 18),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        prefixIcon: Icon(Iconsax.call, size: 18),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _emergencyContactController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact *',
                        prefixIcon: Icon(Iconsax.security, size: 18),
                        hintText: 'Name: Phone Number',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Physical Information
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Physical Information',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                              prefixIcon: Icon(Iconsax.ruler, size: 18),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                              prefixIcon: Icon(Iconsax.weight, size: 18),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _medicalNotesController,
                      decoration: const InputDecoration(
                        labelText: 'Medical Notes',
                        prefixIcon: Icon(Iconsax.health, size: 18),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Subscription Assignment (for new clients)
                    if (client == null) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Subscription Assignment',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Select Plan (Optional)',
                          prefixIcon: Icon(Iconsax.ticket, size: 18),
                        ),
                        items: samplePlans.where((p) => p.isCurrentlyOffered).map((plan) {
                          return DropdownMenuItem<int>(
                            value: plan.id,
                            child: Text('${plan.planName} - ${plan.formattedPrice}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // Value is used but we don't need to store it
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _subscriptionStart,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _subscriptionStart = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                  prefixIcon: Icon(Iconsax.calendar, size: 18),
                                ),
                                child: Text(
                                  DateFormat('MMM d, y').format(_subscriptionStart),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                    ],
                    
                    // Goal Assignment (for new clients)
                    if (client == null) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Assignment (Optional)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          itemCount: sampleGoals.length,
                          itemBuilder: (context, index) {
                            final goal = sampleGoals[index];
                            return CheckboxListTile(
                              title: Text(goal.goalName),
                              subtitle: Text(goal.goalDescription, maxLines: 1, overflow: TextOverflow.ellipsis),
                              value: _selectedGoalIds.contains(goal.id),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedGoalIds.add(goal.id);
                                  } else {
                                    _selectedGoalIds.remove(goal.id);
                                  }
                                });
                              },
                              activeColor: AppColors.yellow,
                              checkColor: AppColors.black,
                              dense: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        client == null 
                            ? 'Client added successfully' 
                            : 'Client updated successfully'
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(client == null ? 'Add Client' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _showClientDetails(Client client) {
    // Get client's subscription
    ClientSubscription? sub = sampleSubscriptions.firstWhere(
      (s) => s.clientId == client.id,
      orElse: () => ClientSubscription(
        id: 0,
        clientId: client.id,
        planId: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        status: 'Expired',
      ),
    );
    
    SubscriptionPlan? plan;
    if (sub.planId > 0) {
      plan = samplePlans.firstWhere((p) => p.id == sub.planId);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(client.fullName),
          content: Container(
            width: 500,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client Avatar and Basic Info
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.yellow.withValues(alpha: 0.2), // FIXED: using withValues
                          child: Text(
                            client.firstName[0],
                            style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          client.fullName,
                          style: AppTextStyles.heading3,
                        ),
                        Text(
                          client.email,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Personal Details
                  const Text(
                    'Personal Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildDetailRow('Gender', client.gender),
                  _buildDetailRow('Age', '${client.age} years'),
                  _buildDetailRow('Date of Birth', DateFormat('MMMM d, y').format(client.dateOfBirth)),
                  _buildDetailRow('Height', '${client.heightCm} cm'),
                  _buildDetailRow('Weight', '${client.currentWeightKg} kg'),
                  _buildDetailRow('BMI', '${client.bmi.toStringAsFixed(1)} (${client.bmiCategory})'),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Contact Details
                  const Text(
                    'Contact Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildDetailRow('Phone', client.contactNumber),
                  _buildDetailRow('Emergency Contact', client.emergencyContact),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Subscription Info
                  const Text(
                    'Membership',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildDetailRow('Status', sub.status),
                  if (plan != null) _buildDetailRow('Plan', plan.planName),
                  if (plan != null) _buildDetailRow('Price', plan.formattedPrice),
                  _buildDetailRow('Member Since', DateFormat('MMMM d, y').format(client.dateRegistered)),
                  if (sub.status == 'Active')
                    _buildDetailRow('Expires', DateFormat('MMMM d, y').format(sub.endDate)),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Medical Notes
                  const Text(
                    'Medical Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      client.medicalNotes ?? 'No medical notes recorded',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showClientForm(client: client);
              },
              icon: const Icon(Iconsax.edit, size: 16),
              label: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Client'),
          content: Text('Are you sure you want to delete ${client.fullName}? This action cannot be undone.'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${client.fullName} has been deleted'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}