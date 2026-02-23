class PlanType {
  final int planTypeId;
  final String planTypeName;

  PlanType({
    required this.planTypeId,
    required this.planTypeName,
  });

  Map<String, dynamic> toMap() {
    return {
      'plan_type_id': planTypeId,
      'plan_type_name': planTypeName,
    };
  }

  factory PlanType.fromMap(Map<String, dynamic> map) {
    return PlanType(
      planTypeId: map['plan_type_id'],
      planTypeName: map['plan_type_name'],
    );
  }
}