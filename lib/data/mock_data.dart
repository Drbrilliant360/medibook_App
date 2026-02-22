import '../models/doctor_model.dart';

class MockData {
  MockData._();

  // --- Departments / Specialties ---
  static const List<Map<String, dynamic>> departments = [
    {'name': 'General Medicine', 'icon': 'local_hospital'},
    {'name': 'Cardiology', 'icon': 'favorite'},
    {'name': 'Dermatology', 'icon': 'face'},
    {'name': 'Pediatrics', 'icon': 'child_care'},
    {'name': 'Orthopedics', 'icon': 'accessibility_new'},
    {'name': 'Gynecology', 'icon': 'pregnant_woman'},
    {'name': 'Neurology', 'icon': 'psychology'},
    {'name': 'Ophthalmology', 'icon': 'visibility'},
    {'name': 'Dentistry', 'icon': 'mood'},
    {'name': 'ENT', 'icon': 'hearing'},
  ];

  static const List<String> specialties = [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Pediatrics',
    'Orthopedics',
    'Gynecology',
    'Neurology',
    'Ophthalmology',
    'Dentistry',
    'ENT',
  ];

  // --- Hospitals in Tanzania ---
  static const List<String> hospitals = [
    'Muhimbili National Hospital',
    'Aga Khan Hospital, Dar es Salaam',
    'Jakaya Kikwete Cardiac Institute',
    'Temeke Regional Hospital',
    'Mwananyamala Regional Hospital',
    'Regency Medical Centre, Dar es Salaam',
    'Hindu Mandal Hospital',
    'TMJ Hospital',
    'Kilimanjaro Christian Medical Centre',
    'Bugando Medical Centre',
  ];

  // --- Locations in Tanzania ---
  static const List<String> locations = [
    'Dar es Salaam',
    'Dodoma',
    'Arusha',
    'Mwanza',
    'Moshi',
    'Zanzibar',
    'Tanga',
    'Morogoro',
  ];

  // --- Time Slots ---
  static const List<String> morningSlots = [
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];

  static const List<String> afternoonSlots = [
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
  ];

  static const List<String> eveningSlots = [
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
  ];

  static List<String> get allTimeSlots =>
      [...morningSlots, ...afternoonSlots, ...eveningSlots];

  // --- Mock Doctors ---
  static const List<DoctorModel> doctors = [
    DoctorModel(
      id: 'doc_01',
      name: 'Dr. Amina Mwinyi',
      specialty: 'Cardiology',
      department: 'Cardiology',
      hospital: 'Jakaya Kikwete Cardiac Institute',
      location: 'Dar es Salaam',
      bio:
          'Dr. Amina Mwinyi is a leading cardiologist with over 15 years of experience in treating heart diseases. She specializes in interventional cardiology and has performed over 2,000 cardiac procedures. She is passionate about preventive cardiology and community heart health awareness.',
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&h=300&fit=crop&crop=face',
      rating: 4.9,
      reviewCount: 234,
      experienceYears: 15,
      consultationFee: 50000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_02',
      name: 'Dr. Joseph Mwalimu',
      specialty: 'General Medicine',
      department: 'General Medicine',
      hospital: 'Muhimbili National Hospital',
      location: 'Dar es Salaam',
      bio:
          'Dr. Joseph Mwalimu is a highly experienced general practitioner serving patients at Muhimbili National Hospital. He is known for his thorough diagnostic approach and compassionate patient care. He has special interest in tropical diseases and infectious disease management.',
      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=300&h=300&fit=crop&crop=face',
      rating: 4.7,
      reviewCount: 189,
      experienceYears: 12,
      consultationFee: 30000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_03',
      name: 'Dr. Fatuma Said',
      specialty: 'Pediatrics',
      department: 'Pediatrics',
      hospital: 'Aga Khan Hospital, Dar es Salaam',
      location: 'Dar es Salaam',
      bio:
          'Dr. Fatuma Said is a dedicated pediatrician with a warm approach to child healthcare. She completed her fellowship in neonatal care and has been serving children in Dar es Salaam for over 10 years. Parents trust her for her gentle manner and thorough care.',
      imageUrl: 'https://images.unsplash.com/photo-1594824476967-48c8b964ac31?w=300&h=300&fit=crop&crop=face',
      rating: 4.8,
      reviewCount: 312,
      experienceYears: 10,
      consultationFee: 45000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Thursday', 'Friday', 'Saturday'],
      languages: ['Swahili', 'English', 'Arabic'],
    ),
    DoctorModel(
      id: 'doc_04',
      name: 'Dr. Peter Makundi',
      specialty: 'Orthopedics',
      department: 'Orthopedics',
      hospital: 'Muhimbili National Hospital',
      location: 'Dar es Salaam',
      bio:
          'Dr. Peter Makundi is a skilled orthopedic surgeon specializing in sports injuries and joint replacement surgery. He trained in South Africa and brings world-class expertise to his patients. He is also involved in training the next generation of orthopedic surgeons.',
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=300&h=300&fit=crop&crop=face',
      rating: 4.6,
      reviewCount: 156,
      experienceYears: 14,
      consultationFee: 55000,
      isAvailableOnline: false,
      availableDays: ['Monday', 'Wednesday', 'Thursday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_05',
      name: 'Dr. Grace Kimaro',
      specialty: 'Gynecology',
      department: 'Gynecology',
      hospital: 'Regency Medical Centre, Dar es Salaam',
      location: 'Dar es Salaam',
      bio:
          'Dr. Grace Kimaro is an experienced gynecologist and obstetrician. She is passionate about women\'s reproductive health and has helped deliver over 3,000 babies safely. She offers comprehensive prenatal and postnatal care.',
      imageUrl: 'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?w=300&h=300&fit=crop&crop=face',
      rating: 4.9,
      reviewCount: 278,
      experienceYears: 16,
      consultationFee: 50000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_06',
      name: 'Dr. Hassan Juma',
      specialty: 'Dermatology',
      department: 'Dermatology',
      hospital: 'Hindu Mandal Hospital',
      location: 'Dar es Salaam',
      bio:
          'Dr. Hassan Juma is a board-certified dermatologist specializing in skin conditions common in tropical climates. He provides expert treatment for eczema, fungal infections, and skin allergies. He also offers cosmetic dermatology services.',
      imageUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=300&h=300&fit=crop&crop=face',
      rating: 4.5,
      reviewCount: 143,
      experienceYears: 9,
      consultationFee: 40000,
      isAvailableOnline: true,
      availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      languages: ['Swahili', 'English', 'Arabic'],
    ),
    DoctorModel(
      id: 'doc_07',
      name: 'Dr. Sarah Ngowi',
      specialty: 'Neurology',
      department: 'Neurology',
      hospital: 'Kilimanjaro Christian Medical Centre',
      location: 'Moshi',
      bio:
          'Dr. Sarah Ngowi is a neurologist based at KCMC in Moshi. She specializes in treating epilepsy, stroke, and headache disorders. She has published research on neurological conditions in East Africa and is committed to improving access to neurological care.',
      imageUrl: 'https://images.unsplash.com/photo-1643297654416-05795d62e39c?w=300&h=300&fit=crop&crop=face',
      rating: 4.7,
      reviewCount: 98,
      experienceYears: 11,
      consultationFee: 45000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_08',
      name: 'Dr. John Mhina',
      specialty: 'ENT',
      department: 'ENT',
      hospital: 'TMJ Hospital',
      location: 'Dar es Salaam',
      bio:
          'Dr. John Mhina is an ENT specialist with extensive experience in treating ear, nose, and throat conditions. He performs both surgical and non-surgical treatments and has a special interest in pediatric ENT care. He is known for his patience and clear communication.',
      imageUrl: 'https://images.unsplash.com/photo-1618498082410-b4aa22193b38?w=300&h=300&fit=crop&crop=face',
      rating: 4.6,
      reviewCount: 167,
      experienceYears: 13,
      consultationFee: 40000,
      isAvailableOnline: false,
      availableDays: ['Monday', 'Tuesday', 'Thursday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_09',
      name: 'Dr. Rehema Kisanga',
      specialty: 'Ophthalmology',
      department: 'Ophthalmology',
      hospital: 'Bugando Medical Centre',
      location: 'Mwanza',
      bio:
          'Dr. Rehema Kisanga is an ophthalmologist dedicated to fighting preventable blindness in Tanzania. She specializes in cataract surgery and glaucoma management. She has participated in remote eye care camps across the Lake Zone region.',
      imageUrl: 'https://images.unsplash.com/photo-1614608682850-e0d6ed316d47?w=300&h=300&fit=crop&crop=face',
      rating: 4.8,
      reviewCount: 205,
      experienceYears: 8,
      consultationFee: 35000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_10',
      name: 'Dr. Daniel Mushi',
      specialty: 'Dentistry',
      department: 'Dentistry',
      hospital: 'Aga Khan Hospital, Dar es Salaam',
      location: 'Dar es Salaam',
      bio:
          'Dr. Daniel Mushi is a skilled dental surgeon offering comprehensive dental care including fillings, root canals, and cosmetic dentistry. He is passionate about oral health education and community outreach programs in schools.',
      imageUrl: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=300&fit=crop&crop=face',
      rating: 4.4,
      reviewCount: 132,
      experienceYears: 7,
      consultationFee: 25000,
      isAvailableOnline: false,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_11',
      name: 'Dr. Mariam Abdallah',
      specialty: 'General Medicine',
      department: 'General Medicine',
      hospital: 'Mwananyamala Regional Hospital',
      location: 'Dar es Salaam',
      bio:
          'Dr. Mariam Abdallah is a general practitioner known for her holistic approach to patient care. She focuses on chronic disease management including diabetes, hypertension, and respiratory conditions. She is fluent in three languages.',
      imageUrl: 'https://images.unsplash.com/photo-1591604021695-0c69b7c05981?w=300&h=300&fit=crop&crop=face',
      rating: 4.7,
      reviewCount: 198,
      experienceYears: 10,
      consultationFee: 25000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Saturday'],
      languages: ['Swahili', 'English', 'Arabic'],
    ),
    DoctorModel(
      id: 'doc_12',
      name: 'Dr. Emmanuel Shirima',
      specialty: 'Cardiology',
      department: 'Cardiology',
      hospital: 'Jakaya Kikwete Cardiac Institute',
      location: 'Dar es Salaam',
      bio:
          'Dr. Emmanuel Shirima is a cardiologist specializing in echocardiography and heart failure management. He completed advanced training at the Jakaya Kikwete Cardiac Institute and works closely with patients to manage cardiovascular risk factors.',
      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=300&h=300&fit=crop&crop=face',
      rating: 4.5,
      reviewCount: 112,
      experienceYears: 8,
      consultationFee: 45000,
      isAvailableOnline: true,
      availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_13',
      name: 'Dr. Zainab Omar',
      specialty: 'Pediatrics',
      department: 'Pediatrics',
      hospital: 'Temeke Regional Hospital',
      location: 'Dar es Salaam',
      bio:
          'Dr. Zainab Omar is a compassionate pediatrician with special interest in childhood nutrition and immunization. She has worked with UNICEF on child health programs in Tanzania and advocates for early childhood development.',
      imageUrl: 'https://images.unsplash.com/photo-1623854767648-e7bb8009f0db?w=300&h=300&fit=crop&crop=face',
      rating: 4.8,
      reviewCount: 245,
      experienceYears: 12,
      consultationFee: 35000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      languages: ['Swahili', 'English', 'Arabic'],
    ),
    DoctorModel(
      id: 'doc_14',
      name: 'Dr. Francis Lyimo',
      specialty: 'Orthopedics',
      department: 'Orthopedics',
      hospital: 'Kilimanjaro Christian Medical Centre',
      location: 'Moshi',
      bio:
          'Dr. Francis Lyimo is an orthopedic surgeon based in Moshi with expertise in trauma surgery and fracture management. He serves patients from across the northern highlands region and has introduced minimally invasive surgical techniques at KCMC.',
      imageUrl: 'https://images.unsplash.com/photo-1666214280557-f1b5022eb634?w=300&h=300&fit=crop&crop=face',
      rating: 4.6,
      reviewCount: 134,
      experienceYears: 11,
      consultationFee: 50000,
      isAvailableOnline: false,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
      languages: ['Swahili', 'English'],
    ),
    DoctorModel(
      id: 'doc_15',
      name: 'Dr. Halima Bakari',
      specialty: 'Gynecology',
      department: 'Gynecology',
      hospital: 'Aga Khan Hospital, Dar es Salaam',
      location: 'Dar es Salaam',
      bio:
          'Dr. Halima Bakari is a gynecologist specializing in high-risk pregnancies and fertility treatment. She completed advanced training in reproductive medicine and provides compassionate, evidence-based care to women of all ages.',
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&h=300&fit=crop&crop=face',
      rating: 4.9,
      reviewCount: 289,
      experienceYears: 14,
      consultationFee: 55000,
      isAvailableOnline: true,
      availableDays: ['Monday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      languages: ['Swahili', 'English'],
    ),
  ];

  // --- Helper Methods ---

  static List<DoctorModel> getDoctorsBySpecialty(String specialty) {
    return doctors.where((d) => d.specialty == specialty).toList();
  }

  static List<DoctorModel> getDoctorsByLocation(String location) {
    return doctors.where((d) => d.location == location).toList();
  }

  static List<DoctorModel> getTopRatedDoctors({int limit = 5}) {
    final sorted = List<DoctorModel>.from(doctors)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(limit).toList();
  }

  static List<DoctorModel> searchDoctors(String query) {
    final q = query.toLowerCase();
    return doctors.where((d) {
      return d.name.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q) ||
          d.hospital.toLowerCase().contains(q) ||
          d.location.toLowerCase().contains(q);
    }).toList();
  }

  static DoctorModel? getDoctorById(String id) {
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Format consultation fee in Tanzanian Shillings
  static String formatFee(double fee) {
    final formatted = fee.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'TSh $formatted';
  }
}
