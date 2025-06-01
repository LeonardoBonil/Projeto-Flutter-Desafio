import 'package:flutter/material.dart';

class ProductStats extends StatelessWidget {
  final Map<String, int> stats;

  const ProductStats({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _StatCard(
            title: 'Total',
            value: stats['total'] ?? 0,
            color: Colors.blue,
          ),
          _StatCard(
            title: 'Em Estoque',
            value: stats['inStock'] ?? 0,
            color: Colors.green,
          ),
          _StatCard(
            title: 'Estoque Baixo',
            value: stats['lowStock'] ?? 0,
            color: Colors.orange,
          ),
          _StatCard(
            title: 'Sem Estoque',
            value: stats['outOfStock'] ?? 0,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}