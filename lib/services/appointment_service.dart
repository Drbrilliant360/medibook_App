import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';
import '../constants/app_constants.dart';

class AppointmentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _db.collection(AppConstants.appointmentsCollection);

  /// Add a new appointment to Firestore
  Future<String> addAppointment(AppointmentModel appointment) async {
    final docRef = await _collection.add(appointment.toMap());
    return docRef.id;
  }

  /// Real-time stream of appointments for a specific patient
  /// Sorts client-side to avoid Firestore composite index requirement.
  Stream<List<AppointmentModel>> getAppointmentsStream(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AppointmentModel.fromDocument(doc))
          .toList();
      list.sort((a, b) => a.date.compareTo(b.date));
      return list;
    });
  }

  /// Fetch appointments once (non-realtime)
  Future<List<AppointmentModel>> getAppointments(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .get();
    final list = snapshot.docs
        .map((doc) => AppointmentModel.fromDocument(doc))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  /// Real-time stream of appointments for a specific doctor
  Stream<List<AppointmentModel>> getDoctorAppointmentsStream(
      String doctorName) {
    return _collection
        .where('doctor', isEqualTo: doctorName)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AppointmentModel.fromDocument(doc))
          .toList();
      list.sort((a, b) => a.date.compareTo(b.date));
      return list;
    });
  }

  /// Stream ALL appointments (for admin)
  Stream<List<AppointmentModel>> getAllAppointmentsStream() {
    return _collection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppointmentModel.fromDocument(doc))
            .toList());
  }

  /// Get all appointments once (for admin reports)
  Future<List<AppointmentModel>> getAllAppointments() async {
    final snapshot =
        await _collection.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromDocument(doc))
        .toList();
  }

  /// Update appointment status
  Future<void> updateStatus(String appointmentId, String status) async {
    await _collection.doc(appointmentId).update({'status': status});
  }

  /// Delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    await _collection.doc(appointmentId).delete();
  }

  /// Get appointment count
  Future<int> getAppointmentCount() async {
    final snapshot = await _collection.count().get();
    return snapshot.count ?? 0;
  }
}
