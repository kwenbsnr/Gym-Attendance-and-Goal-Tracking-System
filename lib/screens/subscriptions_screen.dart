import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/subscription.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedView = 'grid';
  
  final List<String> _filterOptions = const ['All', 'Active', 'Expiring Soon', 'Expired'];
  final List<String> _sortOptions = const ['Recent', 'Price', 'Duration'];
  String _selectedSort = 'Recent';

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
                Tab(text: 'Active Subscriptions'),
                Tab(text: 'Subscription Plans'),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveSubscriptionsContent(),
                _buildPlansContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    double monthlyRevenue = sampleSubscriptions
        .where((s) => s.status == 'Active')
        .fold(0.0, (sum, s) {
          final plan = samplePlans.firstWhere((p) => p.id == s.planId);
          return sum + (plan.price / plan.durationInMonths);
        });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.white,
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subscriptions',
                style: AppTextStyles.heading2,
              ),
              Text(
                'Manage memberships and payments',
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
                const Icon(Iconsax.money, color: AppColors.black),
                const SizedBox(width: 8),
                Text(
                  '₱${monthlyRevenue.toStringAsFixed(0)}/mo',
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

  Widget _buildActiveSubscriptionsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubscriptionsHeader(),
          const SizedBox(height: 24),
          _buildSubscriptionStats(),
          const SizedBox(height: 24),
          _buildSearchFilterBar(),
          const SizedBox(height: 24),
          _buildSubscriptionsView(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsHeader() {
    return Row(
      children: [
        Row(
          children: [
            _buildActionButton(
              'New Subscription',
              Iconsax.add_square,
              AppColors.yellow,
              () => _showNewSubscriptionDialog(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Process Payment',
              Iconsax.money_recive,
              Colors.green,
              () => _showPaymentDialog(),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Renew All',
              Iconsax.refresh,
              AppColors.black,
              () {},
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 5),
                blurRadius: 10,
                offset: Offset(0, 2),
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

  Widget _buildSubscriptionStats() {
    int activeSubs = sampleSubscriptions.where((s) => s.status == 'Active').length;
    int expiringSoon = sampleSubscriptions.where((s) => s.isExpiringSoon).length;
    int expired = sampleSubscriptions.where((s) => s.status == 'Expired').length;
    
    double totalRevenue = sampleSubscriptions
        .where((s) => s.status == 'Active')
        .fold(0.0, (sum, s) {
          final plan = samplePlans.firstWhere((p) => p.id == s.planId);
          return sum + plan.price;
        });

    return Row(
      children: [
        _buildStatCard(
          'Active',
          activeSubs.toString(),
          Iconsax.tick_circle,
          Colors.green,
          'Current members',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Expiring Soon',
          expiringSoon.toString(),
          Iconsax.warning_2,
          Colors.orange,
          'Within 7 days',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Expired',
          expired.toString(),
          Iconsax.close_circle,
          Colors.red,
          'Needs renewal',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Monthly Revenue',
          '₱${totalRevenue.toStringAsFixed(0)}',
          Iconsax.money,
          AppColors.yellow,
          'Active subscriptions',
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
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 5),
              blurRadius: 10,
              offset: Offset(0, 2),
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
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
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

  Widget _buildSubscriptionsView() {
    List<ClientSubscription> filteredSubs = sampleSubscriptions.where((sub) {
      final client = sampleClients.firstWhere(
        (c) => c.id == sub.clientId,
        orElse: () => sampleClients.first,
      );
      
      bool matchesSearch = _searchQuery.isEmpty ||
          client.fullName.toLowerCase().contains(_searchQuery);
      
      bool matchesFilter = true;
      if (_selectedFilter == 'Active') {
        matchesFilter = sub.status == 'Active';
      } else if (_selectedFilter == 'Expiring Soon') {
        matchesFilter = sub.isExpiringSoon;
      } else if (_selectedFilter == 'Expired') {
        matchesFilter = sub.status == 'Expired';
      }
      
      return matchesSearch && matchesFilter;
    }).toList();

    if (filteredSubs.isEmpty) {
      return _buildEmptyState();
    }

    if (_selectedView == 'grid') {
      return _buildSubscriptionsGrid(filteredSubs);
    } else {
      return _buildSubscriptionsList(filteredSubs);
    }
  }

  Widget _buildSubscriptionsGrid(List<ClientSubscription> subscriptions) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        return _buildSubscriptionCard(subscriptions[index]);
      },
    );
  }

  Widget _buildSubscriptionsList(List<ClientSubscription> subscriptions) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
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
                _buildHeaderCell('Plan'),
                _buildHeaderCell('Period'),
                _buildHeaderCell('Status'),
                _buildHeaderCell('Actions', flex: 1),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subscriptions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildSubscriptionListItem(subscriptions[index]);
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

  Widget _buildSubscriptionCard(ClientSubscription subscription) {
    final client = sampleClients.firstWhere(
      (c) => c.id == subscription.clientId,
      orElse: () => sampleClients.first,
    );
    final plan = samplePlans.firstWhere(
      (p) => p.id == subscription.planId,
      orElse: () => samplePlans.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(subscription.status).withValues(alpha: 0.1),
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
                        plan.planName,
                        style: AppTextStyles.smallText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(subscription.status),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price',
                      style: AppTextStyles.smallText,
                    ),
                    Text(
                      plan.formattedPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    _buildInfoChip(
                      Iconsax.calendar,
                      plan.formattedDuration,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Iconsax.money,
                      subscription.paymentMethod ?? 'Cash',
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start',
                          style: AppTextStyles.smallText,
                        ),
                        Text(
                          DateFormat('MMM d').format(subscription.startDate),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Icon(Iconsax.arrow_right, size: 14, color: Colors.grey),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'End',
                          style: AppTextStyles.smallText,
                        ),
                        Text(
                          DateFormat('MMM d, y').format(subscription.endDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: subscription.isExpiringSoon 
                                ? AppColors.error 
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                if (subscription.status == 'Active') ...[
                  const SizedBox(height: 12),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${subscription.daysRemaining} days remaining',
                            style: TextStyle(
                              fontSize: 11,
                              color: subscription.isExpiringSoon 
                                  ? AppColors.error 
                                  : Colors.grey,
                              fontWeight: subscription.isExpiringSoon 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            '${((subscription.daysRemaining / 30) * 100).toStringAsFixed(0)}%',
                            style: AppTextStyles.smallText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: subscription.daysRemaining / 30,
                          backgroundColor: AppColors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            subscription.isExpiringSoon 
                                ? AppColors.error 
                                : Colors.green,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (subscription.status == 'Active')
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _showRenewDialog(subscription),
                          icon: const Icon(Iconsax.refresh, size: 16),
                          label: const Text('Renew'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    if (subscription.status == 'Expired')
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _showNewSubscriptionDialog(client: client),
                          icon: const Icon(Iconsax.add, size: 16),
                          label: const Text('New'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showSubscriptionDetails(subscription),
                        icon: const Icon(Iconsax.more, size: 16),
                        label: const Text('Details'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
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

  Widget _buildSubscriptionListItem(ClientSubscription subscription) {
    final client = sampleClients.firstWhere(
      (c) => c.id == subscription.clientId,
      orElse: () => sampleClients.first,
    );
    final plan = samplePlans.firstWhere(
      (p) => p.id == subscription.planId,
      orElse: () => samplePlans.first,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: subscription.isExpiringSoon 
          ? Colors.orange.withValues(alpha: 0.02)
          : Colors.transparent,
      child: Row(
        children: [
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
                        plan.planName,
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.formattedPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  plan.formattedDuration,
                  style: AppTextStyles.smallText,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat('MMM d').format(subscription.startDate)} -',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  DateFormat('MMM d, y').format(subscription.endDate),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: subscription.isExpiringSoon 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                    color: subscription.isExpiringSoon 
                        ? AppColors.error 
                        : null,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _buildStatusChip(subscription.status),
          ),
          
          Expanded(
            flex: 1,
            child: Row(
              children: [
                if (subscription.status == 'Active')
                  IconButton(
                    icon: const Icon(Iconsax.refresh, size: 18),
                    color: Colors.blue,
                    onPressed: () => _showRenewDialog(subscription),
                    tooltip: 'Renew',
                  ),
                IconButton(
                  icon: const Icon(Iconsax.more, size: 18),
                  color: Colors.grey,
                  onPressed: () => _showSubscriptionDetails(subscription),
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
        color = Colors.green;
        icon = Iconsax.tick_circle;
        break;
      case 'Expired':
        color = Colors.red;
        icon = Iconsax.close_circle;
        break;
      case 'Cancelled':
        color = Colors.orange;
        icon = Iconsax.close_square;
        break;
      case 'Pending':
        color = Colors.blue;
        icon = Iconsax.clock;
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

  Widget _buildPlansContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildActionButton(
                'Create Plan',
                Iconsax.add_square,
                AppColors.yellow,
                () => _showPlanForm(),
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                'Manage Types',
                Iconsax.category,
                AppColors.black,
                () => _showPlanTypesDialog(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ..._buildPlansByType(),
        ],
      ),
    );
  }

  List<Widget> _buildPlansByType() {
    List<Widget> sections = [];
    
    for (var planType in samplePlanTypes) {
      final plans = samplePlans.where((p) => p.planTypeId == planType.id).toList();
      if (plans.isEmpty) continue;
      
      sections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  planType.name,
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${plans.length} plans',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                return _buildPlanCard(plans[index]);
              },
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      );
    }
    
    return sections;
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final planType = samplePlanTypes.firstWhere((t) => t.id == plan.planTypeId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  plan.isCurrentlyOffered 
                      ? AppColors.yellow 
                      : Colors.grey.shade300,
                  plan.isCurrentlyOffered 
                      ? AppColors.darkYellow 
                      : Colors.grey.shade400,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.planName,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        planType.name,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!plan.isCurrentlyOffered)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Inactive',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      plan.formattedPrice,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.yellow,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/${plan.formattedDuration}',
                      style: AppTextStyles.smallText,
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                _buildBenefitItem(Iconsax.calendar, plan.formattedDuration),
                
                const SizedBox(height: 12),
                
                if (plan.benefits != null) ...[
                  const Text(
                    'Benefits:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...plan.benefits!.take(3).map((benefit) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _buildBenefitItem(Iconsax.tick_circle, benefit),
                    ),
                  ),
                  if (plan.benefits!.length > 3)
                    Text(
                      '+${plan.benefits!.length - 3} more',
                      style: AppTextStyles.smallText.copyWith(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                ],
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showPlanDetails(plan),
                        child: const Text('Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showNewSubscriptionDialog(plan: plan),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: AppColors.black,
                        ),
                        child: const Text('Assign'),
                      ),
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

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
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
                Iconsax.ticket,
                size: 48,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No subscriptions found',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty 
                  ? 'Click "New Subscription" to get started'
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
        return Colors.green;
      case 'Expired':
        return Colors.red;
      case 'Cancelled':
        return Colors.orange;
      case 'Pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showNewSubscriptionDialog({Client? client, SubscriptionPlan? plan}) {
    int? selectedClientId = client?.id;
    int? selectedPlanId = plan?.id;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Subscription'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Select Client',
                  prefixIcon: Icon(Iconsax.user, size: 18),
                ),
                initialValue: selectedClientId,
                items: sampleClients.map((c) {
                  return DropdownMenuItem<int>(
                    value: c.id,
                    child: Text(c.fullName),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedClientId = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Select Plan',
                  prefixIcon: Icon(Iconsax.ticket, size: 18),
                ),
                initialValue: selectedPlanId,
                items: samplePlans.map((p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Text('${p.planName} - ${p.formattedPrice}'),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedPlanId = value;
                },
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
                  content: Text('Subscription created successfully'),
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

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Process Payment'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Select Client',
                  prefixIcon: Icon(Iconsax.user, size: 18),
                ),
                items: sampleClients.map((c) {
                  return DropdownMenuItem<int>(
                    value: c.id,
                    child: Text(c.fullName),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Iconsax.money, size: 18),
                  prefixText: '₱',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  prefixIcon: Icon(Iconsax.card, size: 18),
                ),
                initialValue: 'Cash',
                items: const ['Cash', 'Credit Card', 'Bank Transfer', 'GCash']
                    .map((method) => DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {},
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
                  content: Text('Payment processed successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Process'),
          ),
        ],
      ),
    );
  }

  void _showRenewDialog(ClientSubscription subscription) {
    final client = sampleClients.firstWhere((c) => c.id == subscription.clientId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Renew Subscription - ${client.fullName}'),
        content: const Text('Select renewal period:'),
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
                  content: Text('Subscription renewed successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Renew'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDetails(ClientSubscription subscription) {
    final client = sampleClients.firstWhere((c) => c.id == subscription.clientId);
    final plan = samplePlans.firstWhere((p) => p.id == subscription.planId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${client.fullName} - Subscription'),
          content: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Client', client.fullName),
                  _buildDetailRow('Plan', plan.planName),
                  _buildDetailRow('Status', subscription.status),
                  _buildDetailRow('Start Date', DateFormat('MMM d, y').format(subscription.startDate)),
                  _buildDetailRow('End Date', DateFormat('MMM d, y').format(subscription.endDate)),
                  _buildDetailRow('Duration', subscription.formattedDuration),
                  _buildDetailRow('Amount', '₱${plan.price.toStringAsFixed(0)}'),
                  if (subscription.paymentMethod != null)
                    _buildDetailRow('Payment Method', subscription.paymentMethod!),
                  if (subscription.paymentDate != null)
                    _buildDetailRow('Payment Date', DateFormat('MMM d, y').format(subscription.paymentDate!)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (subscription.status == 'Active')
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showRenewDialog(subscription);
                },
                icon: const Icon(Iconsax.refresh, size: 16),
                label: const Text('Renew'),
              ),
          ],
        );
      },
    );
  }

  void _showPlanForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Subscription Plan'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Plan Type',
                    prefixIcon: Icon(Iconsax.category, size: 18),
                  ),
                  items: samplePlanTypes.map((type) {
                    return DropdownMenuItem<int>(
                      value: type.id,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Plan Name',
                    prefixIcon: Icon(Iconsax.ticket, size: 18),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Iconsax.money, size: 18),
                    prefixText: '₱',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Duration (months)',
                    prefixIcon: Icon(Iconsax.calendar, size: 18),
                  ),
                  keyboardType: TextInputType.number,
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
                  content: Text('Plan created successfully'),
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

  void _showPlanTypesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plan Types'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...samplePlanTypes.map((type) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.lightYellow,
                  child: Text(type.id.toString()),
                ),
                title: Text(type.name),
                trailing: IconButton(
                  icon: const Icon(Iconsax.edit, size: 18),
                  onPressed: () {},
                ),
              )),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.yellow,
                  child: Icon(Iconsax.add, color: AppColors.black),
                ),
                title: const Text('Add New Type'),
                onTap: () {
                  Navigator.pop(context);
                },
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
      ),
    );
  }

  void _showPlanDetails(SubscriptionPlan plan) {
    final planType = samplePlanTypes.firstWhere((t) => t.id == plan.planTypeId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(plan.planName),
          content: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Type', planType.name),
                  _buildDetailRow('Price', plan.formattedPrice),
                  _buildDetailRow('Duration', plan.formattedDuration),
                  _buildDetailRow('Status', plan.isCurrentlyOffered ? 'Active' : 'Inactive'),
                  if (plan.description != null) ...[
                    const SizedBox(height: 16),
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(plan.description!),
                  ],
                  if (plan.benefits != null) ...[
                    const SizedBox(height: 16),
                    const Text('Benefits', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...plan.benefits!.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Iconsax.tick_circle, size: 14, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(benefit),
                        ],
                      ),
                    )),
                  ],
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
                _showNewSubscriptionDialog(plan: plan);
              },
              icon: const Icon(Iconsax.user_add, size: 16),
              label: const Text('Assign to Client'),
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