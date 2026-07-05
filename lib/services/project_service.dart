import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'projects';

  final Logger _logger = Logger();

  // Ensure all projects have an 'order' field (migration helper)
  Future<void> ensureProjectOrder() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final batch = _firestore.batch();
      int order = 0;
      for (final doc in snapshot.docs) {
        if (!doc.data().containsKey('order')) {
          batch.update(doc.reference, {'order': order});
        }
        order++;
      }
      await batch.commit();
    } catch (e) {
      _logger.e('Error ensuring project order: $e');
    }
  }

  // Add a new project
  Future<void> addProject({
    required String title,
    required String description,
    required String imageUrl,
    required List<String> technologies,
    required String githubUrl,
    required String youtubeUrl,
    String playStoreUrl = '',
    String demoUrl = '',
  }) async {
    try {
      final count = await _firestore.collection(_collection).count().get();
      await _firestore.collection(_collection).add({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'technologies': technologies,
        'githubUrl': githubUrl,
        'youtubeUrl': youtubeUrl,
        'playStoreUrl': playStoreUrl,
        'demoUrl': demoUrl,
        'order': count.count,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Error adding project: $e');
      rethrow;
    }
  }

  // Get all projects ordered by 'order' field
  Stream<QuerySnapshot> getProjects() {
    return _firestore
        .collection(_collection)
        .orderBy('order', descending: false)
        .snapshots();
  }

  // Reorder projects - takes list of doc IDs in desired order
  Future<void> reorderProjects(List<String> projectIds) async {
    try {
      final batch = _firestore.batch();
      for (int i = 0; i < projectIds.length; i++) {
        batch.update(
          _firestore.collection(_collection).doc(projectIds[i]),
          {'order': i},
        );
      }
      await batch.commit();
    } catch (e) {
      _logger.e('Error reordering projects: $e');
      rethrow;
    }
  }

  // Move a project up or down in order
  Future<void> moveProject(String projectId, int direction) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('order', descending: false)
          .get();
      final docs = snapshot.docs;
      int currentIndex = docs.indexWhere((d) => d.id == projectId);
      if (currentIndex == -1) return;
      int newIndex = currentIndex + direction;
      if (newIndex < 0 || newIndex >= docs.length) return;

      final batch = _firestore.batch();
      batch.update(docs[currentIndex].reference, {'order': newIndex});
      batch.update(docs[newIndex].reference, {'order': currentIndex});
      await batch.commit();
    } catch (e) {
      _logger.e('Error moving project: $e');
      rethrow;
    }
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection(_collection).doc(projectId).delete();
    } catch (e) {
      _logger.e('Error deleting project: $e');
      rethrow;
    }
  }
// Update a project
  Future<void> updateProject({
    required String projectId,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? technologies,
    String? githubUrl,
    String? youtubeUrl, required String playStoreUrl,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (imageUrl != null) updates['imageUrl'] = imageUrl;
      if (technologies != null) updates['technologies'] = technologies;
      if (githubUrl != null) updates['githubUrl'] = githubUrl;
      if (youtubeUrl != null) updates['youtubeUrl'] = youtubeUrl;
      if (playStoreUrl.isNotEmpty) updates['playStoreUrl'] = playStoreUrl;

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_collection).doc(projectId).update(updates);
    } catch (e) {
      _logger.e('Error updating project: $e');
      rethrow;
    }
  }
} 