// lib/utils/validation_utils.dart
class ValidationUtils {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preço é obrigatório';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Preço deve ser maior que zero';
    }
    return null;
  }

  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL da imagem é obrigatória';
    }
    try {
      final uri = Uri.parse(value);
      if (!uri.isAbsolute) {
        return 'URL inválida';
      }
    } catch (e) {
      return 'URL inválida';
    }
    return null;
  }

  static String? validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Estoque é obrigatório';
    }
    final stock = int.tryParse(value);
    if (stock == null || stock < 0) {
      return 'Estoque deve ser maior ou igual a zero';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Categoria é obrigatória';
    }
    return null;
  }
}