import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'portfolio';

  // Profile data
  Future<Map<String, dynamic>?> getProfileData() async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc('profile').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting profile data: $e');
      return null;
    }
  }

  Future<void> updateProfileData(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc('profile').set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating profile data: $e');
      rethrow;
    }
  }

  // About section
  Future<Map<String, dynamic>?> getAboutData() async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc('about').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting about data: $e');
      return null;
    }
  }

  Future<void> updateAboutData(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc('about').set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating about data: $e');
      rethrow;
    }
  }

  // Skills section
  Future<Map<String, dynamic>?> getSkillsData() async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc('skills').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting skills data: $e');
      return null;
    }
  }

  Future<void> updateSkillsData(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc('skills').set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating skills data: $e');
      rethrow;
    }
  }

  // Social links
  Future<Map<String, dynamic>?> getSocialLinksData() async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc('social_links').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting social links data: $e');
      return null;
    }
  }

  Future<void> updateSocialLinksData(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc('social_links').set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating social links data: $e');
      rethrow;
    }
  }

  // CV data
  Future<Map<String, dynamic>?> getCVData() async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc('cv').get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting CV data: $e');
      return null;
    }
  }

  Future<void> updateCVData(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc('cv').set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating CV data: $e');
      rethrow;
    }
  }
}
