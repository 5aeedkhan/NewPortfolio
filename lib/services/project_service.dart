import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'projects';

  // Add a new project
  Future<void> addProject({
    required String title,
    required String description,
    required String imageUrl,
    required List<String> technologies,
    required String projectUrl,
  }) async {
    try {
      await _firestore.collection(_collection).add({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'technologies': technologies,
        'projectUrl': projectUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding project: $e');
      rethrow;
    }
  }

  // Get all projects
  Stream<QuerySnapshot> getProjects() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection(_collection).doc(projectId).delete();
    } catch (e) {
      print('Error deleting project: $e');
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
    String? projectUrl,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (imageUrl != null) updates['imageUrl'] = imageUrl;
      if (technologies != null) updates['technologies'] = technologies;
      if (projectUrl != null) updates['projectUrl'] = projectUrl;
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_collection).doc(projectId).update(updates);
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }
} 