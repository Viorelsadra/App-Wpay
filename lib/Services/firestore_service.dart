import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getTransactions() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> addTransaction(String title, double amount, String type) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add({
        'title': title,
        'amount': amount,
        'type': type,
        'date': Timestamp.now(),
      });
    }
  }

  Future<void> updateTransaction(
      String docId, String title, double amount, String type) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(docId)
          .update({
        'title': title,
        'amount': amount,
        'type': type,
      });
    }
  }

  Future<void> deleteTransaction(String docId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(docId)
          .delete();
    }
  }
}