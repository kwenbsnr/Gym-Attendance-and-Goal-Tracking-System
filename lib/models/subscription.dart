class SubscriptionPlan {
  final int planId;
  final int planTypeId;
  final int durationInMonths;
  final bool isCurrentlyOffered;

  SubscriptionPlan({
    required this.planId,
    required this.planTypeId,
    required this.durationInMonths,
    required this.isCurrentlyOffered,
  });

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
      planId: map['plan_id'],
      planTypeId: map['plan_type_id'],
      durationInMonths: map['duration_in_months'],
      isCurrentlyOffered: map['is_currently_offered'] == 1,
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
    required this.subscriptionId,
    required this.clientId,
    required this.planId,
    required this.subscriptionStart,
    required this.subscriptionEnd,
    required this.subscriptionStatus,
  });

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
      subscriptionId: map['subscription_id'],
      clientId: map['client_id'],
      planId: map['plan_id'],
      subscriptionStart: DateTime.parse(map['subscription_start']),
      subscriptionEnd: DateTime.parse(map['subscription_end']),
      subscriptionStatus: map['subscription_status'],
    );
  }

  int get daysRemaining {
    if (subscriptionStatus != 'Active') return 0;
    return subscriptionEnd.difference(DateTime.now()).inDays.clamp(0, 9999);
  }

  bool get isExpiringSoon => daysRemaining <= 7 && daysRemaining > 0;
}