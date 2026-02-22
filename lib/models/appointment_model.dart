import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String? id;
  final String patientName;
  final String doctor;
  final String? doctorId;
  final String? specialty;
  final DateTime date;
  final String? timeSlot;
  final String appointmentType; // 'physical' or 'online'
  final String? notes;
  final String status;
  final String userId;
  final DateTime? createdAt;

  AppointmentModel({
    this.id,
    required this.patientName,
    required this.doctor,
    this.doctorId,
    this.specialty,
    required this.date,
    this.timeSlot,
    this.appointmentType = 'physical',
    this.notes,
    this.status = 'pending',
    required this.userId,
    this.createdAt,
  });

  /// Convert model → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'doctor': doctor,
      'doctorId': doctorId,
      'specialty': specialty,
      'date': Timestamp.fromDate(date),
      'timeSlot': timeSlot,
      'appointmentType': appointmentType,
      'notes': notes,
      'status': status,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convert Firestore document → model
  factory AppointmentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      patientName: data['patientName'] ?? '',
      doctor: data['doctor'] ?? '',
      doctorId: data['doctorId'],
      specialty: data['specialty'],
      date: (data['date'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'],
      appointmentType: data['appointmentType'] ?? 'physical',
      notes: data['notes'],
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? patientName,
    String? doctor,
    String? doctorId,
    String? specialty,
    DateTime? date,
    String? timeSlot,
    String? appointmentType,
    String? notes,
    String? status,
    String? userId,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      doctor: doctor ?? this.doctor,
      doctorId: doctorId ?? this.doctorId,
      specialty: specialty ?? this.specialty,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      appointmentType: appointmentType ?? this.appointmentType,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}
