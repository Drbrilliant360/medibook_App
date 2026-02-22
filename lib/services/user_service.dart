import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _db.collection(AppConstants.usersCollection);

  Future<void> createOrUpdateUser(UserModel user) async {
    await _collection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromDocument(doc);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _collection.doc(uid).set(data, SetOptions(merge: true));
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _collection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromDocument(doc);
    });
  }

  /// Get all users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    final snapshot =
        await _collection.where('role', isEqualTo: role).get();
    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }

  /// Stream all users by role
  Stream<List<UserModel>> getUsersByRoleStream(String role) {
    return _collection
        .where('role', isEqualTo: role)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => UserModel.fromDocument(doc)).toList());
  }

  /// Get total user count
  Future<int> getUserCount() async {
    final snapshot = await _collection.count().get();
    return snapshot.count ?? 0;
  }

  /// Delete a user document
  Future<void> deleteUser(String uid) async {
    await _collection.doc(uid).delete();
  }
}
