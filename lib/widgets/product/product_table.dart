import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductTable extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String) onDelete;
  final bool loading;

  const ProductTable({
    Key? key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
    this.loading = false,
  }) : super(key: key);

  String _formatPrice(dynamic price) {
    if (price == null) return 'R\$ 0,00';
    try {
      final numPrice = price is String
          ? double.parse(price.replaceAll(',', '.'))
          : (price as num).toDouble();
      return NumberFormat.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
      ).format(numPrice);
    } catch (e) {
      return 'R\$ 0,00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Imagem')),
          DataColumn(label: Text('Nome')),
          DataColumn(label: Text('Descrição')),
          DataColumn(label: Text('Preço')),
          DataColumn(label: Text('Estoque')),
          DataColumn(label: Text('Categoria')),
          DataColumn(label: Text('Ações')),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    product['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image),
                  ),
                ),
              ),
              DataCell(Text(product['name'] ?? '')),
              DataCell(Text(product['description'] ?? '')),
              DataCell(Text(_formatPrice(product['price']))),
              DataCell(Text(product['stock']?.toString() ?? '0')),
              DataCell(Text(product['category'] ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: loading ? null : () => onEdit(product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: loading ? null : () => onDelete(product['id']),
                    color: Colors.red,
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}