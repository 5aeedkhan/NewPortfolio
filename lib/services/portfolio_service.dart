import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'portfolio';
  final String _analyticsCollection = 'analytics';

  // Profile data
  Future<Map<String, dynamic>?> getProfileData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc('profile').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error getting profile data: $e');
      return null;
    }
  }

  Future<void> updateProfileData(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('profile')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating profile data: $e');
      rethrow;
    }
  }

  // About section
  Future<Map<String, dynamic>?> getAboutData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc('about').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error getting about data: $e');
      return null;
    }
  }

  Future<void> updateAboutData(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('about')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating about data: $e');
      rethrow;
    }
  }

  // Skills section
  Future<Map<String, dynamic>?> getSkillsData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc('skills').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error getting skills data: $e');
      return null;
    }
  }

  Future<void> updateSkillsData(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('skills')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating skills data: $e');
      rethrow;
    }
  }

  // Social links
  Future<Map<String, dynamic>?> getSocialLinksData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc('social_links').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error getting social links data: $e');
      return null;
    }
  }

  Future<void> updateSocialLinksData(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('social_links')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating social links data: $e');
      rethrow;
    }
  }

  // CV data
  Future<Map<String, dynamic>?> getCVData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc('cv').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error getting CV data: $e');
      return null;
    }
  }

  Future<void> updateCVData(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('cv')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating CV data: $e');
      rethrow;
    }
  }

  Future<void> trackVisit() async {
    try {
      final docRef = _firestore.collection(_analyticsCollection).doc('visits');
      final historyRef = docRef.collection('visitHistory').doc();
      final batch = _firestore.batch();

      batch.set(
        docRef,
        {
          'total': FieldValue.increment(1),
          'lastVisit': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      batch.set(historyRef, {
        'visitedAt': FieldValue.serverTimestamp(),
        'platform': _resolvePlatformLabel(),
        'isWeb': kIsWeb,
      });

      await batch.commit();
    } catch (e) {
      debugPrint('Error tracking visit: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchVisitStats() {
    return _firestore
        .collection(_analyticsCollection)
        .doc('visits')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchVisitHistory({
    int limit = 20,
  }) {
    return _firestore
        .collection(_analyticsCollection)
        .doc('visits')
        .collection('visitHistory')
        .orderBy('visitedAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  String _resolvePlatformLabel() {
    if (kIsWeb) {
      return 'Web';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }
}
