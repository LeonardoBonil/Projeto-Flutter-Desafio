import 'dart:math';

class MockData {
  static const List<String> categories = [
    'Eletrônicos',
    'Roupas',
    'Acessórios',
    'Livros',
    'Casa e Decoração',
    'Esportes'
  ];

  static const List<String> localImages = [
    'lib/assets/imagem1.jpg',
    'lib/assets/imagem2.jpg',
    'lib/assets/imagem3.jpg',
    'lib/assets/imagem4.jpg'
  ];

  static String getSequentialImage(int index) {
    return localImages[index % localImages.length];
  }

  static List<Map<String, dynamic>> getMockProducts() {
    return List.generate(50, (index) {
      return {
        'id': '${index + 1}',
        'name': 'Produto ${index + 1}',
        'description': 'Descrição detalhada do produto ${index + 1} com informações importantes sobre suas características e benefícios únicos.',
        'price': (Random().nextDouble() * 1000 + 50).toStringAsFixed(2),
        'stock': Random().nextInt(100) + 1,
        'category': categories[Random().nextInt(categories.length)],
        'imageUrl': getSequentialImage(index),
        'createdAt': DateTime.now().toIso8601String(),
      };
    });
  }
}