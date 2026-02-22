import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role; // 'patient', 'doctor', 'admin'
  final String? fullName;
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? address;
  final String? profileImageUrl;
  // Doctor-specific fields
  final String? specialty;
  final String? hospital;
  final String? licenseNumber;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.role = 'patient',
    this.fullName,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.profileImageUrl,
    this.specialty,
    this.hospital,
    this.licenseNumber,
    this.createdAt,
  });

  bool get isPatient => role == 'patient';
  bool get isDoctor => role == 'doctor';
  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'fullName': fullName,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'specialty': specialty,
      'hospital': hospital,
      'licenseNumber': licenseNumber,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'patient',
      fullName: data['fullName'],
      phone: data['phone'],
      dateOfBirth: data['dateOfBirth'],
      gender: data['gender'],
      bloodGroup: data['bloodGroup'],
      address: data['address'],
      profileImageUrl: data['profileImageUrl'],
      specialty: data['specialty'],
      hospital: data['hospital'],
      licenseNumber: data['licenseNumber'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  UserModel copyWith({
    String? role,
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? address,
    String? profileImageUrl,
    String? specialty,
    String? hospital,
    String? licenseNumber,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specialty: specialty ?? this.specialty,
      hospital: hospital ?? this.hospital,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      createdAt: createdAt,
    );
  }
}
