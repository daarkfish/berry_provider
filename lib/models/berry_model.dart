import 'package:flutter/foundation.dart';
import '../../services/api_service.dart';
import '../../models/berry.dart';

class BerryModel extends ChangeNotifier {
  final ApiService _apiService;
  List<Berry> _berries = [];
  List<Berry> _filteredBerries = [];
  Set<int> _favoriteBerryIds = {};
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  BerryModel(this._apiService) {
    fetchBerries();
  }

  List<Berry> get berries => _berries;
  List<Berry> get filteredBerries => _filteredBerries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoriteCount => _favoriteBerryIds.length;

  Future<void> fetchBerries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _berries = await _apiService.getBerries();
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredBerries = _berries;
    } else {
      _filteredBerries = _berries
          .where((berry) =>
              berry.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  bool isBerryFavorite(int berryId) {
    return _favoriteBerryIds.contains(berryId);
  }

  void toggleFavorite(int berryId) {
    if (_favoriteBerryIds.contains(berryId)) {
      _favoriteBerryIds.remove(berryId);
    } else {
      _favoriteBerryIds.add(berryId);
    }
    notifyListeners();
  }

  Future<Berry> getBerryDetails(String name) async {
    try {
      return await _apiService.getBerryDetails(name);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
