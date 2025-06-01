import 'package:flutter/material.dart';
import '/widgets/product/product_card.dart';
import '/model/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String) onDelete;
  final bool loading;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200
            ? 4
            : MediaQuery.of(context).size.width > 800
            ? 3
            : 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        try {
          final product = Product.fromJson(products[index]);
          return ProductCard(
            product: product,
            onEdit: (p) => onEdit(p.toJson()),
            onDelete: onDelete,
            loading: loading,
          );
        } catch (e) {
          return const Card(
            child: Center(
              child: Text('Erro ao carregar produto'),
            ),
          );
        }
      },
    );
  }
}