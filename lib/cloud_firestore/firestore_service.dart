import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Get medicines by type
  Stream<QuerySnapshot> getMedicinesByType(String type) {
    return _db
        .collection('medicines')
        .where('type', isEqualTo: type)
        .snapshots();
  }

  // ✅ Add medicine
  Future<void> addMedicine(String type, String name, String description, String price) {
    return _db.collection('medicines').add({
      'type': type,
      'name': name,
      'description': description,
      'price': price,
    });
  }

  // ✅ Delete medicine
  Future<void> deleteMedicine(String docId) {
    return _db.collection('medicines').doc(docId).delete();
  }

  // ✅ Get all lab tests
  Stream<QuerySnapshot> getLabTests() {
    return _db.collection('lab_tests').snapshots();
  }

  // ✅ Add lab test
  Future<void> addLabTest(String name, String description, String price) {
    return _db.collection('lab_tests').add({
      'name': name,
      'description': description,
      'price': price,
    });
  }

  // ✅ Delete lab test
  Future<void> deleteLabTest(String docId) {
    return _db.collection('lab_tests').doc(docId).delete();
  }
}
