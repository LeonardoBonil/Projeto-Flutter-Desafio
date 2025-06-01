import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_form_screen.dart';
import '/widgets/product/product_card.dart';
import '/widgets/product/product_grid.dart';
import '/widgets/product/product_table.dart';
import '/widgets/product/product_stats.dart';
import '/widgets/product/product_empty_state.dart';
import '/providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _viewMode = 'grid';
  int _page = 0;
  int _rowsPerPage = 12;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.error != null) {
          return Center(child: Text('Erro: ${provider.error}'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gestão de Produtos'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ToggleButtons(
                  isSelected: [_viewMode == 'grid', _viewMode == 'table'],
                  onPressed: (index) => _handleViewModeChange(index == 0 ? 'grid' : 'table'),
                  children: const [
                    Icon(Icons.grid_view),
                    Icon(Icons.table_rows),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _handleEdit(null),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildStats(),
              Expanded(
                child: provider.loading && provider.products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : provider.products.isEmpty
                    ? _buildEmptyState()
                    : _viewMode == 'grid'
                    ? _buildGrid()
                    : _buildTable(),
              ),
              if (provider.products.isNotEmpty) _buildPagination(),
            ],
          ),
        );
      },
    );
  }

  void _handleViewModeChange(String mode) {
    setState(() {
      _viewMode = mode;
      _rowsPerPage = mode == 'grid' ? 12 : 10;
      _page = 0;
    });
    context.read<ProductProvider>().getAllProducts(_page + 1, _rowsPerPage);
  }

  Future<void> _handleEdit(Map<String, dynamic>? product) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ProductFormScreen(product: product),
    );
    if (result == true) {
      context.read<ProductProvider>().getAllProducts(_page + 1, _rowsPerPage);
    }
  }

  Future<void> _handleDelete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await context.read<ProductProvider>().deleteProduct(id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir produto: $e')),
          );
        }
      }
    }
  }

  Widget _buildStats() {
    final provider = context.watch<ProductProvider>();
    return ProductStats(
      stats: {
        'total': provider.total,
        'inStock': provider.products.where((p) => p['stock'] > 0).length,
        'lowStock': provider.products.where((p) => p['stock'] > 0 && p['stock'] <= 5).length,
        'outOfStock': provider.products.where((p) => p['stock'] == 0).length,
      },
    );
  }

  Widget _buildEmptyState() {
    return ProductEmptyState(
      onAdd: () => _handleEdit(null),
    );
  }

  Widget _buildGrid() {
    final provider = context.watch<ProductProvider>();
    return ProductGrid(
      products: provider.products,
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      loading: provider.loading,
    );
  }

  Widget _buildTable() {
    final provider = context.watch<ProductProvider>();
    return ProductTable(
      products: provider.products,
      onEdit: _handleEdit,
      onDelete: _handleDelete,
      loading: provider.loading,
    );
  }

  Widget _buildPagination() {
    final provider = context.watch<ProductProvider>();
    final totalPages = (provider.total / _rowsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: _page == 0
                ? null
                : () {
              setState(() => _page = 0);
              provider.getAllProducts(1, _rowsPerPage);
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _page == 0
                ? null
                : () {
              setState(() => _page--);
              provider.getAllProducts(_page + 1, _rowsPerPage);
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Página ${_page + 1} de $totalPages',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: (_page + 1) >= totalPages
                ? null
                : () {
              setState(() => _page++);
              provider.getAllProducts(_page + 1, _rowsPerPage);
            },
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: (_page + 1) >= totalPages
                ? null
                : () {
              setState(() => _page = totalPages - 1);
              provider.getAllProducts(totalPages, _rowsPerPage);
            },
          ),
        ],
      ),
    );
  }
}