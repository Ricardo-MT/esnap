import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template report_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class ReportRepository {
  /// {@macro report_repository}
  const ReportRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// Sends a feedback message to Firestore.
  Future<void> sendFeedback({
    required String platform,
    required String message,
  }) async {
    await _firestore.collection('feedback').add({
      'platform': platform,
      'message': message,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
