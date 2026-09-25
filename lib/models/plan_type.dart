class PlanType {
  final int planTypeId;
  final String planTypeName;

  const PlanType({
    int? id,
    int? planTypeId,
    String? name,
    String? planTypeName,
  })  : planTypeId = planTypeId ?? id ?? 0,
        planTypeName = planTypeName ?? name ?? '';

  int get id => planTypeId;
  String get name => planTypeName;

  Map<String, dynamic> toMap() {
    return {
      'plan_type_id': planTypeId,
      'plan_type_name': planTypeName,
    };
  }

  factory PlanType.fromMap(Map<String, dynamic> map) {
    return PlanType(
      planTypeId: map['plan_type_id'] ?? map['id'],
      planTypeName: map['plan_type_name'] ?? map['name'] ?? '',
    );
  }
}

// Sample Data
const List<PlanType> samplePlanTypes = [
  PlanType(id: 1, name: 'Monthly'),
  PlanType(id: 2, name: 'Quarterly'),
  PlanType(id: 3, name: 'Annual'),
  PlanType(id: 4, name: 'Per Session'),
  PlanType(id: 5, name: 'Promo'),
];