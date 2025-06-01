import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/mock_data.dart';

class StorageService {
  static const String storageKey = 'products_data';

  Future<List<Map<String, dynamic>>> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(storageKey);
      if (stored != null) {
        final List<dynamic> decoded = json.decode(stored);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Erro ao carregar do storage: $e');
    }
    return MockData.getMockProducts();
  }

  Future<void> saveToStorage(List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(storageKey, json.encode(data));
    } catch (e) {
      print('Erro ao salvar no storage: $e');
    }
  }
}