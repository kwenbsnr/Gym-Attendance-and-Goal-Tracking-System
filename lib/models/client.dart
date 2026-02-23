class Client {
  final int id;
  final String firstName;
  final String lastName;
  final double heightCm;
  final double currentWeightKg;
  final String gender;
  final DateTime dateOfBirth;
  final String contactNumber;
  final String email;
  final String emergencyContact;
  final String? medicalNotes;
  final DateTime dateRegistered;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.heightCm,
    required this.currentWeightKg,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.email,
    required this.emergencyContact,
    this.medicalNotes,
    required this.dateRegistered,
  });

  String get fullName => '$firstName $lastName';
  int get age => DateTime.now().year - dateOfBirth.year;
  
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last';
  }
  
  double get bmi {
    if (heightCm <= 0) return 0;
    final heightInMeters = heightCm / 100;
    return currentWeightKg / (heightInMeters * heightInMeters);
  }
  
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }
}

// Sample data for UI development
List<Client> sampleClients = [
  Client(
    id: 1,
    firstName: 'Mark',
    lastName: 'Marcera',
    heightCm: 175,
    currentWeightKg: 75,
    gender: 'Male',
    dateOfBirth: DateTime(1990, 5, 15),
    contactNumber: '+1 234-567-890',
    email: 'mark.marcera@email.com',
    emergencyContact: 'Jane Marcera: +639-19-567-8912',
    medicalNotes: 'Mild asthma',
    dateRegistered: DateTime(2024, 1, 10),
  ),
  Client(
    id: 2,
    firstName: 'Regin',
    lastName: 'Angala',
    heightCm: 165,
    currentWeightKg: 62,
    gender: 'Female',
    dateOfBirth: DateTime(1995, 8, 22),
    contactNumber: '+1 234-567-892',
    email: 'regin.angala@email.com',
    emergencyContact: 'Larra Tortal: +639-38-567-8935',
    medicalNotes: null,
    dateRegistered: DateTime(2024, 2, 5),
  ),
  Client(
    id: 3,
    firstName: 'Raymart',
    lastName: 'Upao',
    heightCm: 180,
    currentWeightKg: 85,
    gender: 'Male',
    dateOfBirth: DateTime(1988, 11, 3),
    contactNumber: '+1 234-567-894',
    email: 'raymart.upao@email.com',
    emergencyContact: 'Maribel Upao: +639-12-567-8956',
    medicalNotes: 'Previous knee injury',
    dateRegistered: DateTime(2024, 1, 15),
  ),
  Client(
    id: 4,
    firstName: 'Quien',
    lastName: 'Bisnar',
    heightCm: 170,
    currentWeightKg: 68,
    gender: 'Female',
    dateOfBirth: DateTime(1992, 3, 20),
    contactNumber: '+1 234-567-896',
    email: 'quien.bisnar@email.com',
    emergencyContact: 'Mike Bisnar: +639-15-567-8978',
    medicalNotes: null,
    dateRegistered: DateTime(2024, 2, 20),
  ),
  Client(
    id: 5,
    firstName: 'Jack',
    lastName: 'Dawson',
    heightCm: 178,
    currentWeightKg: 82,
    gender: 'Male',
    dateOfBirth: DateTime(1985, 11, 8),
    contactNumber: '+1 234-567-898',
    email: 'jack.dawson@email.com',
    emergencyContact: 'Lisa Dawson: +639-17-567-8990',
    medicalNotes: 'Lower back issues',
    dateRegistered: DateTime(2024, 1, 5),
  ),
];