class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String department;
  final String hospital;
  final String location;
  final String bio;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final double consultationFee;
  final bool isAvailableOnline;
  final List<String> availableDays;
  final List<String> languages;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.department,
    required this.hospital,
    required this.location,
    required this.bio,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.consultationFee,
    required this.isAvailableOnline,
    required this.availableDays,
    required this.languages,
  });

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? department,
    String? hospital,
    String? location,
    String? bio,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? experienceYears,
    double? consultationFee,
    bool? isAvailableOnline,
    List<String>? availableDays,
    List<String>? languages,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      department: department ?? this.department,
      hospital: hospital ?? this.hospital,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experienceYears: experienceYears ?? this.experienceYears,
      consultationFee: consultationFee ?? this.consultationFee,
      isAvailableOnline: isAvailableOnline ?? this.isAvailableOnline,
      availableDays: availableDays ?? this.availableDays,
      languages: languages ?? this.languages,
    );
  }
}
