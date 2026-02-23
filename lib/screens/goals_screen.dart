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

class _GoalsScreenState extends State<GoalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Active, Completed, Paused
  String _selectedView = 'grid'; // grid or list
  
  final List<String> _filterOptions = ['All', 'Active', 'Completed', 'Paused'];
  final List<String> _sortOptions = ['Progress', 'Deadline', 'Client'];
  String _selectedSort = 'Progress';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey,
      child: Column(
        children: [
          // Custom App Bar
          _buildAppBar(),
          
          // Tab Bar
          Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.yellow,
              indicatorWeight: 3,
              labelColor: AppColors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Active Goals'),
                Tab(text: 'Goal Templates'),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Goals Tab
                _buildActiveGoalsContent(),
                
                // Goal Templates Tab
                _buildGoalTemplatesContent(),
              ],
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
                'Goal Tracking',
                style: AppTextStyles.heading2,
              ),
              Text(
                'Monitor and manage client fitness goals',
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
                  '${sampleClientGoals.length} Active Goals',
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

  // ============= ACTIVE GOALS CONTENT =============

  Widget _buildActiveGoalsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Stats and Actions
          _buildActiveGoalsHeader(),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          _buildGoalsStatsSection(),
          
          const SizedBox(height: 24),
          
          // Search, Filter and View Toggle
          _buildSearchFilterBar(),
          
          const SizedBox(height: 24),
          
          // Goals Grid/List
          _buildGoalsView(),
        ],
      ),
    );
  }

  Widget _buildActiveGoalsHeader() {
    return Row(
      children: [
        // Quick Actions
        Row(
          children: [
            _buildActionButton(
              'Assign Goal',
              Iconsax.note_add,
              AppColors.yellow,
              () => _showAssignGoalDialog(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Progress Update',
              Iconsax.chart,
              Colors.green,
              () => _showProgressUpdateDialog(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Generate Report',
              Iconsax.document_download,
              AppColors.black,
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

  Widget _buildGoalsStatsSection() {
    // Calculate stats
    int totalGoals = sampleClientGoals.length;
    int activeGoals = sampleClientGoals.where((g) => g.status == 'Active').length;
    int completedGoals = sampleClientGoals.where((g) => g.status == 'Completed').length;
    double avgProgress = sampleClientGoals
        .where((g) => g.status == 'Active')
        .fold(0.0, (sum, g) => sum + g.progress) / 
        (activeGoals == 0 ? 1 : activeGoals) * 100;

    return Row(
      children: [
        _buildStatCard(
          'Total Goals',
          totalGoals.toString(),
          Iconsax.activity,
          AppColors.yellow,
          'All time',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Active',
          activeGoals.toString(),
          Iconsax.clock,
          Colors.blue,
          'In progress',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Completed',
          completedGoals.toString(),
          Iconsax.tick_circle,
          Colors.green,
          'Achieved',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Avg Progress',
          '${avgProgress.toStringAsFixed(0)}%',
          Iconsax.chart,
          Colors.orange,
          'Active goals',
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
                      hintText: 'Search by client or goal name...',
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

  Widget _buildGoalsView() {
    // Filter goals based on search and status
    List<ClientGoal> filteredGoals = sampleClientGoals.where((goal) {
      final client = sampleClients.firstWhere(
        (c) => c.id == goal.clientId,
        orElse: () => sampleClients.first,
      );
      final goalTemplate = sampleGoals.firstWhere(
        (g) => g.id == goal.goalId,
        orElse: () => sampleGoals.first,
      );
      
      bool matchesSearch = _searchQuery.isEmpty ||
          client.fullName.toLowerCase().contains(_searchQuery) ||
          goalTemplate.goalName.toLowerCase().contains(_searchQuery);
      
      bool matchesFilter = _selectedFilter == 'All' || goal.status == _selectedFilter;
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredGoals.isEmpty) {
      return _buildEmptyState();
    }

    if (_selectedView == 'grid') {
      return _buildGoalsGrid(filteredGoals);
    } else {
      return _buildGoalsList(filteredGoals);
    }
  }

  Widget _buildGoalsGrid(List<ClientGoal> goals) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return _buildGoalCard(goals[index]);
      },
    );
  }

  Widget _buildGoalsList(List<ClientGoal> goals) {
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
                _buildHeaderCell('Client & Goal', flex: 2),
                _buildHeaderCell('Progress'),
                _buildHeaderCell('Deadline'),
                _buildHeaderCell('Status'),
                _buildHeaderCell('Actions', flex: 1),
              ],
            ),
          ),
          
          // List Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: goals.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildGoalListItem(goals[index]);
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

  Widget _buildGoalCard(ClientGoal clientGoal) {
    final client = sampleClients.firstWhere(
      (c) => c.id == clientGoal.clientId,
      orElse: () => sampleClients.first,
    );
    final goal = sampleGoals.firstWhere(
      (g) => g.id == clientGoal.goalId,
      orElse: () => sampleGoals.first,
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
              color: _getStatusColor(clientGoal.status).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    goal.icon ?? Iconsax.activity,
                    color: AppColors.yellow,
                    size: 20,
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
                        goal.goalName,
                        style: AppTextStyles.smallText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(clientGoal.status),
              ],
            ),
          ),
          
          // Card Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: AppTextStyles.smallText,
                        ),
                        Text(
                          clientGoal.formattedProgress,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: clientGoal.progress,
                        backgroundColor: AppColors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(clientGoal.progress),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Goal Details
                Row(
                  children: [
                    _buildInfoChip(
                      Iconsax.calendar,
                      '${clientGoal.targetDaysPerWeek}/week',
                    ),
                    const SizedBox(width: 8),
                    if (clientGoal.targetValue != null)
                      _buildInfoChip(
                        Iconsax.ruler,
                        '${clientGoal.targetValue} ${clientGoal.unit ?? ''}',
                      ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Deadline and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline',
                          style: AppTextStyles.smallText.copyWith(fontSize: 10),
                        ),
                        Text(
                          _formatDeadline(clientGoal),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: clientGoal.daysRemaining < 7 
                                ? AppColors.error 
                                : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.chart, size: 16),
                          color: Colors.blue,
                          onPressed: () => _showProgressUpdateDialog(goal: clientGoal),
                          tooltip: 'Update Progress',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.more, size: 16),
                          color: Colors.grey,
                          onPressed: () => _showGoalDetails(clientGoal),
                          tooltip: 'View Details',
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

  Widget _buildGoalListItem(ClientGoal clientGoal) {
    final client = sampleClients.firstWhere(
      (c) => c.id == clientGoal.clientId,
      orElse: () => sampleClients.first,
    );
    final goal = sampleGoals.firstWhere(
      (g) => g.id == clientGoal.goalId,
      orElse: () => sampleGoals.first,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: clientGoal.daysRemaining < 7 && clientGoal.status == 'Active'
          ? AppColors.error.withValues(alpha: 0.02)
          : Colors.transparent,
      child: Row(
        children: [
          // Client & Goal
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
                        goal.goalName,
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      clientGoal.formattedProgress,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    if (clientGoal.targetValue != null)
                      Text(
                        ' (${clientGoal.currentValue?.toStringAsFixed(0)}/${clientGoal.targetValue?.toStringAsFixed(0)} ${clientGoal.unit})',
                        style: AppTextStyles.smallText.copyWith(fontSize: 11),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: clientGoal.progress,
                      backgroundColor: AppColors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(clientGoal.progress),
                      ),
                      minHeight: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Deadline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM d, y').format(clientGoal.endDate ?? clientGoal.startDate),
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  '${clientGoal.daysRemaining} days left',
                  style: AppTextStyles.smallText.copyWith(
                    color: clientGoal.daysRemaining < 7 ? AppColors.error : null,
                  ),
                ),
              ],
            ),
          ),
          
          // Status
          Expanded(
            child: _buildStatusChip(clientGoal.status),
          ),
          
          // Actions
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.chart, size: 18),
                  color: Colors.blue,
                  onPressed: () => _showProgressUpdateDialog(goal: clientGoal),
                  tooltip: 'Update Progress',
                ),
                IconButton(
                  icon: const Icon(Iconsax.more, size: 18),
                  color: Colors.grey,
                  onPressed: () => _showGoalDetails(clientGoal),
                  tooltip: 'View Details',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case 'Active':
        color = Colors.blue;
        icon = Iconsax.clock;
        break;
      case 'Completed':
        color = Colors.green;
        icon = Iconsax.tick_circle;
        break;
      case 'Paused':
        color = Colors.orange;
        icon = Iconsax.pause;
        break;
      case 'Abandoned':
        color = Colors.red;
        icon = Iconsax.close_circle;
        break;
      default:
        color = Colors.grey;
        icon = Iconsax.activity;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============= GOAL TEMPLATES CONTENT =============

  Widget _buildGoalTemplatesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _buildActionButton(
                'Create Template',
                Iconsax.note_add,
                AppColors.yellow,
                () => _showTemplateForm(),
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                'Import Templates',
                Iconsax.document_upload,
                AppColors.black,
                () {},
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Templates Grid
          _buildTemplatesGrid(),
        ],
      ),
    );
  }

  Widget _buildTemplatesGrid() {
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
        return _buildTemplateCard(sampleGoals[index]);
      },
    );
  }

  Widget _buildTemplateCard(Goal goal) {
    // Count how many clients have this goal
    int usageCount = sampleClientGoals.where((cg) => cg.goalId == goal.id).length;

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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.lightYellow,
              borderRadius: BorderRadius.only(
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
                        '$usageCount clients',
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showAssignGoalDialog(template: goal),
                      icon: const Icon(Iconsax.user_add, size: 16),
                      label: const Text('Assign'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.yellow,
                        side: const BorderSide(color: AppColors.yellow),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Iconsax.copy, size: 16),
                              SizedBox(width: 8),
                              Text('Duplicate'),
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

  // ============= HELPER METHODS =============

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
                Iconsax.activity,
                size: 48,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No goals found',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty 
                  ? 'Click "Assign Goal" to get started'
                  : 'Try adjusting your search or filter',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Paused':
        return Colors.orange;
      case 'Abandoned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.6) return Colors.orange;
    if (progress < 0.9) return Colors.blue;
    return Colors.green;
  }

  String _formatDeadline(ClientGoal goal) {
    if (goal.endDate == null) return 'No deadline';
    if (goal.daysRemaining < 0) return 'Overdue';
    if (goal.daysRemaining == 0) return 'Today';
    if (goal.daysRemaining == 1) return 'Tomorrow';
    return '${goal.daysRemaining} days';
  }

  void _showAssignGoalDialog({Goal? template}) {
    // Implementation would show client selection and goal assignment form
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Goal'),
        content: const Text('Goal assignment form would go here'),
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
                  content: Text('Goal assigned successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _showProgressUpdateDialog({ClientGoal? goal}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Current Value',
                suffixText: goal?.unit ?? '',
              ),
              keyboardType: TextInputType.number,
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
                const SnackBar(
                  content: Text('Progress updated successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showGoalDetails(ClientGoal clientGoal) {
    final client = sampleClients.firstWhere(
      (c) => c.id == clientGoal.clientId,
      orElse: () => sampleClients.first,
    );
    final goal = sampleGoals.firstWhere(
      (g) => g.id == clientGoal.goalId,
      orElse: () => sampleGoals.first,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${client.fullName} - ${goal.goalName}'),
          content: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress
                  const Text('Progress', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: clientGoal.progress,
                            backgroundColor: AppColors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(clientGoal.progress),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        clientGoal.formattedProgress,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Details
                  _buildDetailRow('Client', client.fullName),
                  _buildDetailRow('Goal Type', goal.goalName),
                  _buildDetailRow('Status', clientGoal.status),
                  _buildDetailRow('Start Date', DateFormat('MMM d, y').format(clientGoal.startDate)),
                  if (clientGoal.endDate != null)
                    _buildDetailRow('End Date', DateFormat('MMM d, y').format(clientGoal.endDate!)),
                  _buildDetailRow('Target', '${clientGoal.targetDaysPerWeek} days/week'),
                  if (clientGoal.targetValue != null)
                    _buildDetailRow('Target Value', '${clientGoal.targetValue} ${clientGoal.unit}'),
                  if (clientGoal.currentValue != null)
                    _buildDetailRow('Current Value', '${clientGoal.currentValue} ${clientGoal.unit}'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (clientGoal.status == 'Active')
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showProgressUpdateDialog(goal: clientGoal);
                },
                icon: const Icon(Iconsax.chart, size: 16),
                label: const Text('Update Progress'),
              ),
          ],
        );
      },
    );
  }

  void _showTemplateForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Goal Template'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  prefixIcon: Icon(Iconsax.activity, size: 18),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                  content: Text('Template created successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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