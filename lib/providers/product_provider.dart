import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../model/product.dart';

class ProductProvider extends ChangeNotifier {
  final _storageService = StorageService();
  List<Map<String, dynamic>> _products = [];
  bool _loading = false;
  String? _error;
  int _total = 0;

  List<Map<String, dynamic>> get products => _products;
  bool get loading => _loading;
  String? get error => _error;
  int get total => _total;

  Future<void> init() async {
    await getAllProducts(1, 12);
  }

  Future<void> getAllProducts(int page, int limit) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final allProducts = await _storageService.loadFromStorage();
      _total = allProducts.length;

      await Future.delayed(const Duration(milliseconds: 300));

      final start = (page - 1) * limit;
      final end = start + limit;
      _products = allProducts.sublist(
        start,
        end > allProducts.length ? allProducts.length : end,
      );

      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar produtos: $e';
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> productData) async {
    try {
      _loading = true;
      notifyListeners();

      final allProducts = await _storageService.loadFromStorage();
      final newId = (allProducts.isEmpty ? 0 : allProducts.map((p) => int.parse(p['id'].toString())).reduce((a, b) => a > b ? a : b)) + 1;

      final newProduct = {
        ...productData,
        'id': newId.toString(),
        'imageUrl': productData['imageUrl'] ?? 'lib/assets/imagem1.png',
        'createdAt': DateTime.now().toIso8601String(),
      };

      allProducts.insert(0, newProduct);
      await _storageService.saveToStorage(allProducts);

      await getAllProducts(1, _products.length);
      return newProduct;
    } catch (e) {
      _error = 'Erro ao adicionar produto: $e';
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> productData) async {
    try {
      _loading = true;
      notifyListeners();

      final allProducts = await _storageService.loadFromStorage();
      final index = allProducts.indexWhere((p) => p['id'] == productData['id']);

      if (index != -1) {
        final updatedProduct = {
          ...allProducts[index],
          ...productData,
          'updatedAt': DateTime.now().toIso8601String(),
        };

        allProducts[index] = updatedProduct;
        await _storageService.saveToStorage(allProducts);

        await getAllProducts(1, _products.length);
        return updatedProduct;
      }
      throw Exception('Produto não encontrado');
    } catch (e) {
      _error = 'Erro ao atualizar produto: $e';
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      _loading = true;
      notifyListeners();

      final allProducts = await _storageService.loadFromStorage();
      allProducts.removeWhere((p) => p['id'] == id);
      await _storageService.saveToStorage(allProducts);

      await getAllProducts(1, _products.length);
    } catch (e) {
      _error = 'Erro ao deletar produto: $e';
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }
}