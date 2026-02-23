class Client {
  final int clientId;
  final String firstName;
  final String lastName;
  final double? heightCm;
  final double? currentWeightKg;
  final String? gender;
  final DateTime? dateOfBirth;
  final String contactNumber;
  final String email;
  final String emergencyContact;
  final String? medicalNotes;
  final DateTime dateRegistered;

  Client({
    required this.clientId,
    required this.firstName,
    required this.lastName,
    this.heightCm,
    this.currentWeightKg,
    this.gender,
    this.dateOfBirth,
    required this.contactNumber,
    required this.email,
    required this.emergencyContact,
    this.medicalNotes,
    required this.dateRegistered,
  });

  String get fullName => '$firstName $lastName';
  
  int? get age {
    if (dateOfBirth == null) return null;
    return DateTime.now().year - dateOfBirth!.year;
  }
  
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last';
  }
  
  double? get bmi {
    if (heightCm == null || currentWeightKg == null || heightCm! <= 0) return null;
    final heightInMeters = heightCm! / 100;
    return currentWeightKg! / (heightInMeters * heightInMeters);
  }
  
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toMap() {
    return {
      'client_id': clientId,
      'first_name': firstName,
      'last_name': lastName,
      'height_cm': heightCm,
      'current_weight_kg': currentWeightKg,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'contact_number': contactNumber,
      'email': email,
      'emergency_contact': emergencyContact,
      'medical_notes': medicalNotes,
      'date_registered': dateRegistered.toIso8601String(),
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      clientId: map['client_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      heightCm: map['height_cm']?.toDouble(),
      currentWeightKg: map['current_weight_kg']?.toDouble(),
      gender: map['gender'],
      dateOfBirth: map['date_of_birth'] != null 
          ? DateTime.parse(map['date_of_birth']) 
          : null,
      contactNumber: map['contact_number'],
      email: map['email'],
      emergencyContact: map['emergency_contact'],
      medicalNotes: map['medical_notes'],
      dateRegistered: DateTime.parse(map['date_registered']),
    );
  }
}