import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/models/attendance.dart';
import 'package:flutter_application_try_0/models/client.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Checked In, Checked Out
  
  final List<String> _filterOptions = ['All', 'Checked In', 'Checked Out'];

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
                  // Header with Date Picker and Actions
                  _buildHeaderSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Cards
                  _buildStatsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Search and Filter Bar
                  _buildSearchFilterBar(),
                  
                  const SizedBox(height: 24),
                  
                  // Attendance Table/List
                  _buildAttendanceList(),
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
                'Attendance Management',
                style: AppTextStyles.heading2,
              ),
              Text(
                'Track and manage client check-ins',
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
                const Icon(Iconsax.calendar, color: AppColors.black),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
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
        // Date Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              IconButton(
                icon: const Icon(Iconsax.arrow_left, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                  });
                },
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    DateFormat('MMMM d, y').format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE').format(_selectedDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Iconsax.arrow_right, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                  });
                },
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Action Buttons
        Row(
          children: [
            _buildActionButton(
              'Check In',
              Iconsax.login,
              AppColors.success,
              () => _showCheckInDialog(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Check Out',
              Iconsax.logout,
              AppColors.error,
              () => _showCheckOutDialog(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Export',
              Iconsax.document_download,
              AppColors.yellow,
              () {},
            ),
          ],
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

  Widget _buildStatsSection() {
    // Calculate stats from sample data
    int totalToday = sampleAttendance.length;
    int checkedIn = sampleAttendance.where((a) => a.isCheckedIn && !a.isCheckedOut).length;
    int completed = sampleAttendance.where((a) => a.isCheckedOut).length;
    int expected = 25; // Example expected check-ins for today

    return Row(
      children: [
        _buildStatCard(
          'Total Today',
          totalToday.toString(),
          Iconsax.people,
          AppColors.yellow,
          'Expected: $expected',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Currently In',
          checkedIn.toString(),
          Iconsax.login,
          Colors.blue,
          'Active now',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Completed',
          completed.toString(),
          Iconsax.tick_circle,
          Colors.green,
          'Checked out',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Check-in Rate',
          '${((totalToday / expected) * 100).toStringAsFixed(0)}%',
          Iconsax.chart,
          Colors.orange,
          '${expected - totalToday} remaining',
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
                  hintText: 'Search by client name...',
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
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    // Filter attendance based on search and filter
    List<Attendance> filteredAttendance = sampleAttendance.where((attendance) {
      // Find client
      final client = sampleClients.firstWhere(
        (c) => c.id == attendance.clientId,
        orElse: () => sampleClients.first,
      );
      
      // Apply search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          client.fullName.toLowerCase().contains(_searchQuery);
      
      // Apply status filter
      bool matchesFilter = true;
      if (_selectedFilter == 'Checked In') {
        matchesFilter = attendance.isCheckedIn && !attendance.isCheckedOut;
      } else if (_selectedFilter == 'Checked Out') {
        matchesFilter = attendance.isCheckedOut;
      }
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredAttendance.isEmpty) {
      return _buildEmptyState();
    }

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
                _buildHeaderCell('Client', flex: 2),
                _buildHeaderCell('Check In'),
                _buildHeaderCell('Check Out'),
                _buildHeaderCell('Duration'),
                _buildHeaderCell('Status'),
                _buildHeaderCell('Actions', flex: 0.8),
              ],
            ),
          ),
          
          // Table Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredAttendance.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final attendance = filteredAttendance[index];
              final client = sampleClients.firstWhere(
                (c) => c.id == attendance.clientId,
                orElse: () => sampleClients.first,
              );
              
              return _buildAttendanceRow(attendance, client);
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

  Widget _buildAttendanceRow(Attendance attendance, Client client) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: attendance.isCheckedOut 
          ? Colors.green.withValues(alpha: 0.02)
          : (attendance.isCheckedIn 
              ? Colors.blue.withValues(alpha: 0.02)
              : Colors.transparent),
      child: Row(
        children: [
          // Client
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        client.email,
                        style: AppTextStyles.smallText.copyWith(
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Check In Time
          Expanded(
            child: _buildTimeCell(
              attendance.formattedCheckInTime,
              attendance.isCheckedIn,
            ),
          ),
          
          // Check Out Time
          Expanded(
            child: _buildTimeCell(
              attendance.formattedCheckOutTime,
              attendance.isCheckedOut,
            ),
          ),
          
          // Duration
          Expanded(
            child: Text(
              attendance.formattedDuration,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Status
          Expanded(
            child: _buildStatusChip(attendance),
          ),
          
          // Actions
          Expanded(
            flex: 1,
            child: Row(
              children: [
                if (!attendance.isCheckedOut)
                  IconButton(
                    icon: const Icon(Iconsax.logout, size: 18),
                    color: Colors.blue,
                    onPressed: attendance.isCheckedIn 
                        ? () => _showCheckOutDialog(client: client)
                        : () => _showCheckInDialog(client: client),
                    tooltip: attendance.isCheckedIn ? 'Check Out' : 'Check In',
                  ),
                IconButton(
                  icon: const Icon(Iconsax.more, size: 18),
                  color: Colors.grey,
                  onPressed: () => _showAttendanceDetails(attendance, client),
                  tooltip: 'View Details',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCell(String time, bool isValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
            color: isValid ? AppColors.black : Colors.grey,
          ),
        ),
        if (isValid) ...[
          const SizedBox(height: 2),
          Text(
            DateFormat('MMM d, y').format(DateTime.now()),
            style: AppTextStyles.smallText.copyWith(fontSize: 10),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip(Attendance attendance) {
    if (attendance.isCheckedOut) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(76, 175, 80, 0.1),
          borderRadius: BorderRadius.circular(20),
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
              'Completed',
              style: TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (attendance.isCheckedIn) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(33, 150, 243, 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.clock, color: Colors.blue, size: 12),
            SizedBox(width: 4),
            Text(
              'Active',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 11,
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.close_circle, color: Colors.grey, size: 12),
            SizedBox(width: 4),
            Text(
              'Absent',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
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
                Iconsax.receipt,
                size: 48,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No attendance records found',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filter',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckInDialog({Client? client}) {
    // Get available clients (not checked in)
    List<Client> availableClients = sampleClients.where((c) {
      return !sampleAttendance.any((a) => a.clientId == c.id && a.isCheckedIn && !a.isCheckedOut);
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Check In Client'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (client == null) ...[
                  const Text('Select client to check in:'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: availableClients.length,
                      itemBuilder: (context, index) {
                        final c = availableClients[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.lightYellow,
                            child: Text(c.firstName[0]),
                          ),
                          title: Text(c.fullName),
                          subtitle: Text(c.email),
                          onTap: () {
                            Navigator.pop(context);
                            _performCheckIn(c);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckOutDialog({Client? client}) {
    // Get clients currently checked in
    List<Client> checkedInClients = sampleClients.where((c) {
      return sampleAttendance.any((a) => a.clientId == c.id && a.isCheckedIn && !a.isCheckedOut);
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Check Out Client'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (client == null) ...[
                  const Text('Select client to check out:'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: checkedInClients.length,
                      itemBuilder: (context, index) {
                        final c = checkedInClients[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.lightYellow,
                            child: Text(c.firstName[0]),
                          ),
                          title: Text(c.fullName),
                          subtitle: Text('Checked in: ${_getCheckInTime(c)}'),
                          onTap: () {
                            Navigator.pop(context);
                            _performCheckOut(c);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getCheckInTime(Client client) {
    final attendance = sampleAttendance.firstWhere(
      (a) => a.clientId == client.id && a.isCheckedIn && !a.isCheckedOut,
    );
    return attendance.formattedCheckInTime;
  }

  void _performCheckIn(Client client) {
    // In real implementation, this would add to database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${client.fullName} checked in successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _performCheckOut(Client client) {
    // In real implementation, this would update database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${client.fullName} checked out successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showAttendanceDetails(Attendance attendance, Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance Details'),
          content: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Client:', client.fullName),
                _buildDetailRow('Date:', DateFormat('MMMM d, y').format(attendance.attendanceDate)),
                _buildDetailRow('Check In:', attendance.formattedCheckInTime),
                _buildDetailRow('Check Out:', attendance.formattedCheckOutTime),
                _buildDetailRow('Duration:', attendance.formattedDuration),
                _buildDetailRow('Status:', attendance.isCheckedOut ? 'Completed' : (attendance.isCheckedIn ? 'Active' : 'Absent')),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}