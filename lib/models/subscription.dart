class SubscriptionPlan {
  final int planId;
  final int planTypeId;
  final String? planName;
  final int durationInMonths;
  final double? price;
  final bool isCurrentlyOffered;
  final String? description;
  final List<String>? benefits;

  const SubscriptionPlan({
    int? id,
    int? planId,
    required this.planTypeId,
    this.planName,
    required this.durationInMonths,
    this.price,
    required this.isCurrentlyOffered,
    this.description,
    this.benefits,
  }) : planId = planId ?? id ?? 0;

  int get id => planId;
  String get name => planName ?? 'Plan $planId';
  String get formattedPrice => '₱${(price ?? (durationInMonths * 1500.0)).toStringAsFixed(0)}';
  String get formattedDuration => durationInMonths == 1 
      ? 'Monthly' 
      : (durationInMonths == 0 ? 'Per Session' : '$durationInMonths Months');

  Map<String, dynamic> toMap() {
    return {
      'plan_id': planId,
      'plan_type_id': planTypeId,
      'duration_in_months': durationInMonths,
      'is_currently_offered': isCurrentlyOffered ? 1 : 0,
    };
  }

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlan(
      planId: map['plan_id'] ?? map['id'] ?? 0,
      planTypeId: map['plan_type_id'] ?? 1,
      planName: map['plan_name'],
      durationInMonths: map['duration_in_months'] ?? 1,
      price: map['price']?.toDouble(),
      isCurrentlyOffered: map['is_currently_offered'] == 1 || map['is_currently_offered'] == true,
      description: map['description'],
      benefits: map['benefits'] != null ? List<String>.from(map['benefits']) : null,
    );
  }
}

class ClientSubscription {
  final int subscriptionId;
  final int clientId;
  final int planId;
  final DateTime subscriptionStart;
  final DateTime subscriptionEnd;
  final String subscriptionStatus; // 'Active', 'Expired', 'Paused'

  ClientSubscription({
    int? id,
    int? subscriptionId,
    required this.clientId,
    required this.planId,
    DateTime? startDate,
    DateTime? subscriptionStart,
    DateTime? endDate,
    DateTime? subscriptionEnd,
    String? status,
    String? subscriptionStatus,
  })  : subscriptionId = subscriptionId ?? id ?? 0,
        subscriptionStart = subscriptionStart ?? startDate ?? DateTime.now(),
        subscriptionEnd = subscriptionEnd ?? endDate ?? DateTime.now().add(const Duration(days: 30)),
        subscriptionStatus = subscriptionStatus ?? status ?? 'Active';

  int get id => subscriptionId;
  DateTime get startDate => subscriptionStart;
  DateTime get endDate => subscriptionEnd;
  String get status => subscriptionStatus;

  int get daysRemaining {
    if (subscriptionStatus != 'Active') return 0;
    return subscriptionEnd.difference(DateTime.now()).inDays.clamp(0, 9999);
  }

  bool get isExpiringSoon => daysRemaining <= 7 && daysRemaining > 0;
  bool get isExpired => daysRemaining <= 0 && subscriptionStatus == 'Active';

  String get formattedDuration {
    final totalDays = subscriptionEnd.difference(subscriptionStart).inDays;
    final months = (totalDays / 30).round();
    return '$months month${months > 1 ? 's' : ''}';
  }

  Map<String, dynamic> toMap() {
    return {
      'subscription_id': subscriptionId,
      'client_id': clientId,
      'plan_id': planId,
      'subscription_start': subscriptionStart.toIso8601String(),
      'subscription_end': subscriptionEnd.toIso8601String(),
      'subscription_status': subscriptionStatus,
    };
  }

  factory ClientSubscription.fromMap(Map<String, dynamic> map) {
    return ClientSubscription(
      subscriptionId: map['subscription_id'] ?? map['id'] ?? 0,
      clientId: map['client_id'] ?? 0,
      planId: map['plan_id'] ?? 0,
      subscriptionStart: map['subscription_start'] != null
          ? DateTime.parse(map['subscription_start'])
          : (map['start_date'] != null ? DateTime.parse(map['start_date']) : DateTime.now()),
      subscriptionEnd: map['subscription_end'] != null
          ? DateTime.parse(map['subscription_end'])
          : (map['end_date'] != null ? DateTime.parse(map['end_date']) : DateTime.now()),
      subscriptionStatus: map['subscription_status'] ?? map['status'] ?? 'Active',
    );
  }
}

// Sample Data
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