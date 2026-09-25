import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_try_0/utils/constants.dart';
import 'package:flutter_application_try_0/models/client.dart';
import 'package:flutter_application_try_0/models/subscription.dart';
import 'package:flutter_application_try_0/models/plan_type.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  String _selectedCategory = 'Active';
  

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
                  // Category Stats Grid
                  _buildCategoryStats(),
                  
                  const SizedBox(height: 32),
                  
                  // Selected Category Details
                  _buildCategoryDetails(),
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
                  'Subscriptions',
                  style: isMobile ? AppTextStyles.heading3 : AppTextStyles.heading2,
                ),
                Text(
                  'Manage memberships and renewals',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============= CATEGORY STATS GRID =============

  Widget _buildCategoryStats() {
    int activeCount = sampleSubscriptions.where((s) => s.status == 'Active').length;
    int expiringCount = sampleSubscriptions.where((s) => s.isExpiringSoon).length;
    int expiredCount = sampleSubscriptions.where((s) => s.status == 'Expired').length;
    int pausedCount = sampleSubscriptions.where((s) => s.status == 'Paused').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 650 ? 2 : 4;
        final childAspectRatio = constraints.maxWidth < 650 ? 1.4 : 1.5;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: [
            _buildCategoryCard(
              'Active Subs',
              activeCount.toString(),
              Iconsax.tick_circle,
              Colors.green,
              'Currently active',
              'Active',
            ),
            _buildCategoryCard(
              'Expiring Soon',
              expiringCount.toString(),
              Iconsax.warning_2,
              Colors.orange,
              'Within 5 days',
              'Expiring Soon',
            ),
            _buildCategoryCard(
              'Expired Subs',
              expiredCount.toString(),
              Iconsax.close_circle,
              Colors.red,
              'Needs renewal',
              'Expired',
            ),
            _buildCategoryCard(
              'Paused Subs',
              pausedCount.toString(),
              Iconsax.pause,
              Colors.blue,
              'On hold',
              'Paused',
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(String label, String value, IconData icon, Color color, String subtitle, String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedCategory == category 
                ? AppColors.yellow 
                : Colors.transparent,
            width: 2,
          ),
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
                    color: AppColors.withOpacity(color, 0.1),
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
            const SizedBox(height: 6),
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
      ),
    );
  }

  // ============= CATEGORY DETAILS LIST =============

  Widget _buildCategoryDetails() {
    List<ClientSubscription> filteredSubs = _getFilteredSubscriptions();
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    if (filteredSubs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Iconsax.ticket,
                size: 48,
                color: AppColors.withOpacity(Colors.grey, 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No $_selectedCategory subscriptions',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
        ),
      );
    }

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$_selectedCategory Subscriptions',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${filteredSubs.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredSubs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildMobileSubscriptionCard(filteredSubs[index]);
            },
          ),
        ],
      );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '$_selectedCategory Subscriptions',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${filteredSubs.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // List Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildHeaderCell('Client Name', flex: 2),
                _buildHeaderCell('Plan Type'),
                _buildHeaderCell('Start Date'),
                _buildHeaderCell('End Date'),
                _buildHeaderCell('Status'),
                _buildHeaderCell('Days Remaining'),
              ],
            ),
          ),
          
          // List Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredSubs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildSubscriptionListItem(filteredSubs[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSubscriptionCard(ClientSubscription subscription) {
    final client = sampleClients.firstWhere(
      (c) => c.id == subscription.clientId,
      orElse: () => sampleClients.first,
    );
    final plan = samplePlans.firstWhere(
      (p) => p.id == subscription.planId,
      orElse: () => samplePlans.first,
    );
    final planType = samplePlanTypes.firstWhere(
      (t) => t.id == plan.planTypeId,
      orElse: () => samplePlanTypes.first,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.withOpacity(AppColors.yellow, 0.2),
                child: Text(
                  client.firstName.isNotEmpty ? client.firstName[0] : '?',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
              _buildStatusChip(subscription.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plan', style: AppTextStyles.caption.copyWith(fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('${planType.name} (${plan.name})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Duration', style: AppTextStyles.caption.copyWith(fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    '${DateFormat('MMM d').format(subscription.startDate)} - ${DateFormat('MMM d, y').format(subscription.endDate)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          if (subscription.status == 'Active') ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${subscription.daysRemaining} days remaining',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: subscription.isExpiringSoon ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<ClientSubscription> _getFilteredSubscriptions() {
    if (_selectedCategory == 'Active') {
      return sampleSubscriptions.where((s) => s.status == 'Active').toList();
    } else if (_selectedCategory == 'Expiring Soon') {
      return sampleSubscriptions.where((s) => s.isExpiringSoon).toList();
    } else if (_selectedCategory == 'Expired') {
      return sampleSubscriptions.where((s) => s.status == 'Expired').toList();
    } else if (_selectedCategory == 'Paused') {
      return sampleSubscriptions.where((s) => s.status == 'Paused').toList();
    }
    return [];
  }

  Widget _buildHeaderCell(String label, {double flex = 1}) {
    return Expanded(
      flex: flex ~/ 1,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.grey,
        ),
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
    final planType = samplePlanTypes.firstWhere(
      (t) => t.id == plan.planTypeId,
      orElse: () => samplePlanTypes.first,
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
                  radius: 16,
                  backgroundColor: AppColors.withOpacity(AppColors.yellow, 0.2),
                  child: Text(
                    client.firstName[0],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
                        client.email,
                        style: AppTextStyles.smallText.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Plan Type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planType.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  plan.name,
                  style: AppTextStyles.smallText.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Start Date
          Expanded(
            child: Text(
              DateFormat('MMM d, y').format(subscription.startDate),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          
          // End Date
          Expanded(
            child: Text(
              DateFormat('MMM d, y').format(subscription.endDate),
              style: TextStyle(
                fontSize: 13,
                color: subscription.isExpiringSoon ? Colors.orange : null,
              ),
            ),
          ),
          
          // Status
          Expanded(
            child: _buildStatusChip(subscription.status),
          ),
          
          // Days Remaining
          Expanded(
            child: Text(
              subscription.status == 'Active'
                  ? '${subscription.daysRemaining} days'
                  : '--',
              style: TextStyle(
                fontSize: 13,
                fontWeight: subscription.isExpiringSoon 
                    ? FontWeight.w600 
                    : FontWeight.normal,
                color: subscription.isExpiringSoon 
                    ? Colors.orange 
                    : null,
              ),
            ),
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
      case 'Paused':
        color = Colors.orange;
        icon = Iconsax.pause;
        break;
      default:
        color = Colors.grey;
        icon = Iconsax.activity;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(color, 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.withOpacity(color, 0.3),
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
}