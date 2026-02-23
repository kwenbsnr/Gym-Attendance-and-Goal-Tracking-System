import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/attendance.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Active, Inactive
  String _selectedView = 'grid'; // grid or list
  
  final List<String> _filterOptions = ['All', 'Active', 'Inactive'];
  final List<String> _sortOptions = ['Name', 'Recent', 'Attendance'];
  String _selectedSort = 'Name';
  
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
                  
                  // Clients Grid/List
                  _buildClientsView(),
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
                'Manage and track all gym members',
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
        // Quick Actions
        Row(
          children: [
            _buildActionButton(
              'Add New Client',
              Iconsax.user_add,
              AppColors.yellow,
              () => _showClientForm(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Import List',
              Iconsax.document_upload,
              AppColors.black,
              () {},
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Export',
              Iconsax.document_download,
              Colors.green,
              () {},
            ),
          ],
        ),
        
        const Spacer(),
        
        // View Toggle
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
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
              _buildViewToggleButton(Iconsax.element_4, 'grid'),
              _buildViewToggleButton(Iconsax.element_3, 'list'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
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

  Widget _buildStatsSection() {
    // Calculate stats
    int totalClients = sampleClients.length;
    int activeToday = sampleAttendance
        .where((a) => 
            a.attendanceDate.year == DateTime.now().year &&
            a.attendanceDate.month == DateTime.now().month &&
            a.attendanceDate.day == DateTime.now().day)
        .length;
    int withGoals = 15; // Example
    int expiringSoon = 3; // Example

    return Row(
      children: [
        _buildStatCard(
          'Total Clients',
          totalClients.toString(),
          Iconsax.people,
          AppColors.yellow,
          'All members',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Active Today',
          activeToday.toString(),
          Iconsax.activity,
          Colors.green,
          'Checked in',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'With Goals',
          withGoals.toString(),
          Iconsax.note,
          Colors.blue,
          'Active goals',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Expiring Soon',
          expiringSoon.toString(),
          Iconsax.warning_2,
          Colors.orange,
          'Next 7 days',
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, String subtitle) {
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
                color: Color.fromRGBO(
                  (color.r * 255).round().clamp(0, 255),
                  (color.g * 255).round().clamp(0, 255),
                  (color.b * 255).round().clamp(0, 255),
                  0.1,
                ),
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
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
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
      child: Column(
        children: [
          Row(
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
                      hintText: 'Search by name, email, or phone...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Iconsax.search_normal, size: 20),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Filter Chips
              Expanded(
                child: Row(
                  children: _filterOptions.map((filter) {
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
                              fontSize: 13,
                              fontWeight: _selectedFilter == filter 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: AppColors.grey,
                          selectedColor: AppColors.yellow,
                          checkmarkColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              
              // Sort Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _selectedSort,
                  icon: const Icon(Iconsax.arrow_down, size: 18),
                  elevation: 16,
                  style: const TextStyle(color: AppColors.black),
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSort = newValue!;
                    });
                  },
                  items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Iconsax.arrow_swap, size: 14),
                          const SizedBox(width: 8),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientsView() {
    // Filter clients based on search
    List<Client> filteredClients = sampleClients.where((client) {
      bool matchesSearch = _searchQuery.isEmpty ||
          client.fullName.toLowerCase().contains(_searchQuery) ||
          client.email.toLowerCase().contains(_searchQuery) ||
          client.contactNumber.contains(_searchQuery);
      
      // Apply status filter (simplified for now)
      bool matchesFilter = true;
      if (_selectedFilter == 'Active') {
        matchesFilter = sampleAttendance.any((a) => 
            a.clientId == client.id && 
            a.attendanceDate.year == DateTime.now().year &&
            a.attendanceDate.month == DateTime.now().month &&
            a.attendanceDate.day == DateTime.now().day);
      } else if (_selectedFilter == 'Inactive') {
        matchesFilter = !sampleAttendance.any((a) => 
            a.clientId == client.id && 
            a.attendanceDate.year == DateTime.now().year &&
            a.attendanceDate.month == DateTime.now().month &&
            a.attendanceDate.day == DateTime.now().day);
      }
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredClients.isEmpty) {
      return _buildEmptyState();
    }

    if (_selectedView == 'grid') {
      return _buildClientsGrid(filteredClients);
    } else {
      return _buildClientsList(filteredClients);
    }
  }

  Widget _buildClientsGrid(List<Client> clients) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        return _buildClientCard(clients[index]);
      },
    );
  }

  Widget _buildClientsList(List<Client> clients) {
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
          // List Header
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
                _buildHeaderCell('Client', flex: 2),
                _buildHeaderCell('Contact'),
                _buildHeaderCell('Membership'),
                _buildHeaderCell('Status'),
                _buildHeaderCell('Actions', flex: 0.8),
              ],
            ),
          ),
          
          // List Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clients.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildClientListItem(clients[index]);
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

  Widget _buildClientCard(Client client) {
    // Get client's attendance status for today
    bool isActiveToday = sampleAttendance.any((a) => 
        a.clientId == client.id && 
        a.attendanceDate.year == DateTime.now().year &&
        a.attendanceDate.month == DateTime.now().month &&
        a.attendanceDate.day == DateTime.now().day);

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
          // Card Header with Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActiveToday 
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromRGBO(
                    (AppColors.yellow.r * 255).round().clamp(0, 255),
                    (AppColors.yellow.g * 255).round().clamp(0, 255),
                    (AppColors.yellow.b * 255).round().clamp(0, 255),
                    0.2,
                  ),
                  child: Text(
                    client.firstName[0],
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                        style: AppTextStyles.smallText.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Iconsax.more, size: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
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
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Iconsax.eye, size: 16),
                          SizedBox(width: 8),
                          Text('View Details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'attendance',
                      child: Row(
                        children: [
                          Icon(Iconsax.calendar_tick, size: 16),
                          SizedBox(width: 8),
                          Text('Attendance'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Card Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildInfoRow(Iconsax.call, client.contactNumber),
                const SizedBox(height: 8),
                _buildInfoRow(Iconsax.health, '${client.age} years • ${client.bmiCategory}'),
                const SizedBox(height: 12),
                
                // Membership Info
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Member since:',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, y').format(client.dateRegistered),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(isActiveToday),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.login, size: 16),
                          color: Colors.blue,
                          onPressed: () {},
                          tooltip: 'Check In',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.note, size: 16),
                          color: AppColors.yellow,
                          onPressed: () {},
                          tooltip: 'Add Goal',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
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

  Widget _buildClientListItem(Client client) {
    bool isActiveToday = sampleAttendance.any((a) => 
        a.clientId == client.id && 
        a.attendanceDate.year == DateTime.now().year &&
        a.attendanceDate.month == DateTime.now().month &&
        a.attendanceDate.day == DateTime.now().day);

    return Container(
      padding: const EdgeInsets.all(16),
      color: isActiveToday 
          ? Colors.green.withValues(alpha: 0.02)
          : Colors.transparent,
      child: Row(
        children: [
          // Client Info
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromRGBO(
                    (AppColors.yellow.r * 255).round().clamp(0, 255),
                    (AppColors.yellow.g * 255).round().clamp(0, 255),
                    (AppColors.yellow.b * 255).round().clamp(0, 255),
                    0.2,
                  ),
                  child: Text(
                    client.firstName[0],
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
          
          // Contact
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.contactNumber,
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  'Emergency: ${client.emergencyContact.substring(0, 15)}...',
                  style: AppTextStyles.smallText.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Membership
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Since ${DateFormat('MMM y').format(client.dateRegistered)}',
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  '${client.age} years',
                  style: AppTextStyles.smallText,
                ),
              ],
            ),
          ),
          
          // Status
          Expanded(
            child: _buildStatusBadge(isActiveToday),
          ),
          
          // Actions
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.login, size: 18),
                  color: Colors.blue,
                  onPressed: () {},
                  tooltip: 'Check In',
                ),
                IconButton(
                  icon: const Icon(Iconsax.note, size: 18),
                  color: AppColors.yellow,
                  onPressed: () {},
                  tooltip: 'Add Goal',
                ),
                IconButton(
                  icon: const Icon(Iconsax.more, size: 18),
                  color: Colors.grey,
                  onPressed: () => _showClientDetails(client),
                  tooltip: 'View Details',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.tick_circle, color: Colors.green, size: 12),
            SizedBox(width: 4),
            Text(
              'Active Today',
              style: TextStyle(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.clock, color: Colors.grey, size: 12),
            SizedBox(width: 4),
            Text(
              'Inactive',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }
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
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(client == null ? 'Add New Client' : 'Edit Client'),
          content: Container(
            width: 500,
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
                              labelText: 'First Name',
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
                              labelText: 'Last Name',
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
                            initialValue: _selectedGender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
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
                                labelText: 'Date of Birth',
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
                        labelText: 'Email Address',
                        prefixIcon: Icon(Iconsax.sms, size: 18),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Iconsax.call, size: 18),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _emergencyContactController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact',
                        prefixIcon: Icon(Iconsax.security, size: 18),
                        hintText: 'Name: Phone Number',
                      ),
                      maxLines: 2,
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
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear controllers
                _firstNameController.clear();
                _lastNameController.clear();
                _emailController.clear();
                _phoneController.clear();
                _heightController.clear();
                _weightController.clear();
                _emergencyContactController.clear();
                _medicalNotesController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save client logic here
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(client.fullName),
          content: Container(
            width: 400,
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
                          backgroundColor: Color.fromRGBO(
                            (AppColors.yellow.r * 255).round().clamp(0, 255),
                            (AppColors.yellow.g * 255).round().clamp(0, 255),
                            (AppColors.yellow.b * 255).round().clamp(0, 255),
                            0.2,
                          ),
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
                  
                  // Membership
                  const Text(
                    'Membership',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildDetailRow('Member Since', DateFormat('MMMM d, y').format(client.dateRegistered)),
                  _buildDetailRow('Medical Notes', client.medicalNotes ?? 'None'),
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