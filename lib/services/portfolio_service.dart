import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html if (dart.library.html) 'dart:html' show window;

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

  // Contact info
  Future<Map<String, dynamic>?> getContactInfo() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collection).doc('contactInfo').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error getting contact info: $e');
      return null;
    }
  }

  Future<void> updateContactInfo(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('contactInfo')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating contact info: $e');
      rethrow;
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

  // Experience section
  Future<List<Map<String, dynamic>>> getExperienceData() async {
    try {
      final snapshot = await _firestore
          .collection('experience')
          .orderBy('order', descending: false)
          .get();
      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      debugPrint('Error getting experience data: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getExperienceStream() {
    return _firestore
        .collection('experience')
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  Future<void> addExperienceItem(Map<String, dynamic> data) async {
    try {
      final count = await _firestore.collection('experience').count().get();
      data['order'] = count.count;
      data['createdAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('experience').add(data);
    } catch (e) {
      debugPrint('Error adding experience item: $e');
      rethrow;
    }
  }

  Future<void> updateExperienceItem(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('experience').doc(id).update(data);
    } catch (e) {
      debugPrint('Error updating experience item: $e');
      rethrow;
    }
  }

  Future<void> deleteExperienceItem(String id) async {
    try {
      await _firestore.collection('experience').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting experience item: $e');
      rethrow;
    }
  }

  // Hero stats
  Future<List<Map<String, dynamic>>> getHeroStats() async {
    try {
      final doc =
          await _firestore.collection(_collection).doc('hero_stats').get();
      if (doc.exists && doc.data()!['stats'] != null) {
        final List<dynamic> stats = doc.data()!['stats'];
        return stats.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting hero stats: $e');
      return [];
    }
  }

  Future<void> updateHeroStats(List<Map<String, dynamic>> stats) async {
    try {
      await _firestore.collection(_collection).doc('hero_stats').set({
        'stats': stats,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating hero stats: $e');
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
        if (kIsWeb) ..._collectWebInfo(),
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

  // Contact messages
  Future<void> submitContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await _firestore.collection('contact_messages').add({
        'name': name,
        'email': email,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      debugPrint('Error submitting contact message: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchContactMessages({
    int limit = 20,
  }) {
    return _firestore
        .collection('contact_messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> markMessageAsRead(String docId) async {
    try {
      await _firestore.collection('contact_messages').doc(docId).update({
        'read': true,
      });
    } catch (e) {
      debugPrint('Error marking message as read: $e');
      rethrow;
    }
  }

  Future<void> deleteMessage(String docId) async {
    try {
      await _firestore.collection('contact_messages').doc(docId).delete();
    } catch (e) {
      debugPrint('Error deleting message: $e');
      rethrow;
    }
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

  Map<String, dynamic> _collectWebInfo() {
    try {
      final ua = html.window.navigator.userAgent;
      String browser = 'Unknown';
      if (ua.contains('Edg/')) {
        browser = 'Edge';
      } else if (ua.contains('OPR/') || ua.contains('Opera/')) {
        browser = 'Opera';
      } else if (ua.contains('Chrome/')) {
        browser = 'Chrome';
      } else if (ua.contains('Firefox/')) {
        browser = 'Firefox';
      } else if (ua.contains('Safari/')) {
        browser = 'Safari';
      }

      String os = 'Unknown';
      if (ua.contains('Windows')) {
        os = 'Windows';
      } else if (ua.contains('Mac OS')) {
        os = 'macOS';
      } else if (ua.contains('Linux')) {
        os = 'Linux';
      } else if (ua.contains('Android')) {
        os = 'Android';
      } else if (ua.contains('iPhone') || ua.contains('iPad')) {
        os = 'iOS';
      }

      final screenWidth = html.window.screen?.width ?? 0;
      final screenHeight = html.window.screen?.height ?? 0;
      final isMobile = screenWidth > 0 && screenWidth < 768;

      String referrer = '';
      try {
        referrer = html.window.location.href;
      } catch (_) {}
      if (referrer.isEmpty) referrer = 'Direct';

      return {
        'browser': browser,
        'os': os,
        'userAgent': ua,
        'screenSize': '${screenWidth}x$screenHeight',
        'isMobile': isMobile,
        'language': html.window.navigator.language ?? 'Unknown',
        'referrer': referrer,
        'timezone': DateTime.now().timeZoneName ?? 'Unknown',
      };
    } catch (e) {
      debugPrint('Error collecting web info: $e');
      return {};
    }
  }
}
