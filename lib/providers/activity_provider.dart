import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../data/dummy_activities.dart';

/// ActivityProvider adalah satu-satunya pemilik (single source of truth)
/// dari seluruh data aktivitas di aplikasi ini. Semua layar membaca dan
/// mengubah data lewat provider ini, sehingga daftar aktivitas, jumlah
/// selesai, dan status favorit selalu konsisten di semua layar.
class ActivityProvider extends ChangeNotifier {
  final List<Activity> _activities = generateDummyActivities();

  // State pencarian & filter disimpan di sini juga, supaya nilainya
  // tetap sama walau berpindah layar lalu kembali lagi.
  String _searchQuery = '';
  String? _categoryFilter; // null = semua kategori
  bool? _statusFilter; // null = semua, true = selesai, false = belum

  List<Activity> get allActivities => List.unmodifiable(_activities);

  List<Activity> get filteredActivities {
    return _activities.where((a) {
      final matchSearch =
          _searchQuery.isEmpty ||
          a.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory =
          _categoryFilter == null || a.category == _categoryFilter;
      final matchStatus = _statusFilter == null || a.isDone == _statusFilter;
      return matchSearch && matchCategory && matchStatus;
    }).toList();
  }

  List<Activity> get favoriteActivities =>
      _activities.where((a) => a.isFavorite).toList();

  int get totalActivities => _activities.length;
  int get doneCount => _activities.where((a) => a.isDone).length;
  int get favoriteCount => _activities.where((a) => a.isFavorite).length;

  String get searchQuery => _searchQuery;
  String? get categoryFilter => _categoryFilter;
  bool? get statusFilter => _statusFilter;

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setCategoryFilter(String? value) {
    _categoryFilter = value;
    notifyListeners();
  }

  void setStatusFilter(bool? value) {
    _statusFilter = value;
    notifyListeners();
  }

  Activity? getById(String id) {
    try {
      return _activities.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  String _generateNewId() {
    final maxNum = _activities.isEmpty
        ? 0
        : _activities
              .map((a) => int.tryParse(a.id.replaceAll('A', '')) ?? 0)
              .reduce((a, b) => a > b ? a : b);
    return 'A${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  void addActivity({
    required String title,
    required String category,
    required String description,
    required DateTime deadline,
  }) {
    _activities.add(
      Activity(
        id: _generateNewId(),
        title: title,
        category: category,
        description: description,
        deadline: deadline,
      ),
    );
    notifyListeners();
  }

  void updateActivity(
    String id, {
    required String title,
    required String category,
    required String description,
    required DateTime deadline,
  }) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index == -1) return;
    _activities[index] = _activities[index].copyWith(
      title: title,
      category: category,
      description: description,
      deadline: deadline,
    );
    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index == -1) return;
    _activities[index] = _activities[index].copyWith(
      isFavorite: !_activities[index].isFavorite,
    );
    notifyListeners();
  }

  void toggleDone(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index == -1) return;
    _activities[index] = _activities[index].copyWith(
      isDone: !_activities[index].isDone,
    );
    notifyListeners();
  }
}
