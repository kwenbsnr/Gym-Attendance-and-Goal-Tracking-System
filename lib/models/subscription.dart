class PlanType {
  final int id;
  final String name;

  const PlanType({
    required this.id,
    required this.name,
  });
}

class SubscriptionPlan {
  final int id;
  final int planTypeId;
  final String planName;
  final int durationInMonths;
  final double price;
  final bool isCurrentlyOffered;
  final String? description;
  final List<String>? benefits;

  const SubscriptionPlan({
    required this.id,
    required this.planTypeId,
    required this.planName,
    required this.durationInMonths,
    required this.price,
    required this.isCurrentlyOffered,
    this.description,
    this.benefits,
  });

  String get formattedPrice => '₱${price.toStringAsFixed(0)}';
  String get formattedDuration => durationInMonths == 1 
      ? 'Monthly' 
      : '$durationInMonths Months';
}

class ClientSubscription {
  final int id;
  final int clientId;
  final int planId;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'Active', 'Expired', 'Paused'

  ClientSubscription({
    required this.id,
    required this.clientId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  int get daysRemaining {
    if (status != 'Active') return 0;
    return endDate.difference(DateTime.now()).inDays.clamp(0, 9999);
  }

  bool get isExpiringSoon => daysRemaining <= 7 && daysRemaining > 0;
  bool get isExpired => daysRemaining <= 0 && status == 'Active';
  
  String get formattedDuration {
    final totalDays = endDate.difference(startDate).inDays;
    final months = (totalDays / 30).round();
    return '$months month${months > 1 ? 's' : ''}';
  }
}

// Sample Data
const List<PlanType> samplePlanTypes = [
  PlanType(id: 1, name: 'Basic'),
  PlanType(id: 2, name: 'Standard'),
  PlanType(id: 3, name: 'Premium'),
];

const List<SubscriptionPlan> samplePlans = [
  SubscriptionPlan(
    id: 1,
    planTypeId: 1,
    planName: 'Basic Monthly',
    durationInMonths: 1,
    price: 1500,
    isCurrentlyOffered: true,
    description: 'Access to gym facilities during regular hours',
    benefits: [
      'Gym access 6am-10pm',
      'Locker room access',
      'Basic equipment',
    ],
  ),
  SubscriptionPlan(
    id: 2,
    planTypeId: 1,
    planName: 'Basic Quarterly',
    durationInMonths: 3,
    price: 4000,
    isCurrentlyOffered: true,
    description: 'Save with quarterly payment',
    benefits: [
      'Gym access 6am-10pm',
      'Locker room access',
      'Basic equipment',
      'Free fitness assessment',
    ],
  ),
  SubscriptionPlan(
    id: 3,
    planTypeId: 2,
    planName: 'Standard Monthly',
    durationInMonths: 1,
    price: 2500,
    isCurrentlyOffered: true,
    description: 'Full gym access with classes',
    benefits: [
      'Gym access 5am-11pm',
      'Group classes included',
      'Locker with towel service',
    ],
  ),
  SubscriptionPlan(
    id: 4,
    planTypeId: 2,
    planName: 'Standard Annual',
    durationInMonths: 12,
    price: 24000,
    isCurrentlyOffered: true,
    description: 'Best value annual plan',
    benefits: [
      '24/7 gym access',
      'Unlimited group classes',
      'Premium locker with towel',
      '2 guest passes monthly',
    ],
  ),
  SubscriptionPlan(
    id: 5,
    planTypeId: 3,
    planName: 'Premium Monthly',
    durationInMonths: 1,
    price: 3500,
    isCurrentlyOffered: true,
    description: 'All-inclusive premium experience',
    benefits: [
      '24/7 gym access',
      'Unlimited classes',
      'Personal training (2x/month)',
      'Nutrition planning',
    ],
  ),
];

List<ClientSubscription> sampleSubscriptions = [
  ClientSubscription(
    id: 1,
    clientId: 1,
    planId: 3,
    startDate: DateTime.now().subtract(const Duration(days: 45)),
    endDate: DateTime.now().add(const Duration(days: 15)),
    status: 'Active',
  ),
  ClientSubscription(
    id: 2,
    clientId: 2,
    planId: 4,
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now().add(const Duration(days: 335)),
    status: 'Active',
  ),
  ClientSubscription(
    id: 3,
    clientId: 3,
    planId: 1,
    startDate: DateTime.now().subtract(const Duration(days: 60)),
    endDate: DateTime.now().subtract(const Duration(days: 30)),
    status: 'Expired',
  ),
  ClientSubscription(
    id: 4,
    clientId: 4,
    planId: 2,
    startDate: DateTime.now().subtract(const Duration(days: 10)),
    endDate: DateTime.now().add(const Duration(days: 20)),
    status: 'Active',
  ),
  ClientSubscription(
    id: 5,
    clientId: 5,
    planId: 5,
    startDate: DateTime.now().subtract(const Duration(days: 90)),
    endDate: DateTime.now().add(const Duration(days: 275)),
    status: 'Active',
  ),
];