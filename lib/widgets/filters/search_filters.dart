// lib/widgets/filters/search_filters.dart
import 'package:flutter/material.dart';

class SearchFilters extends StatefulWidget {
  final Function(String) onSearchChange;
  final Function(String) onCategoryChange;
  final Function(RangeValues) onPriceRangeChange;
  final List<String> categories;
  final RangeValues priceRange;
  final String currentCategory;
  final String searchTerm;

  const SearchFilters({
    Key? key,
    required this.onSearchChange,
    required this.onCategoryChange,
    required this.onPriceRangeChange,
    required this.categories,
    required this.priceRange,
    required this.currentCategory,
    required this.searchTerm,
  }) : super(key: key);

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  late TextEditingController _searchController;
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
    _currentRangeValues = widget.priceRange;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar produtos',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: widget.onSearchChange,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: widget.currentCategory,
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('Todas as categorias'),
                ),
                ...widget.categories.map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                )),
              ],
              onChanged: (value) => widget.onCategoryChange(value ?? ''),
            ),
            const SizedBox(height: 16),
            const Text(
              'Faixa de Preço',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: _currentRangeValues,
              min: widget.priceRange.start,
              max: widget.priceRange.end,
              divisions: 100,
              labels: RangeLabels(
                'R\$${_currentRangeValues.start.toStringAsFixed(2)}',
                'R\$${_currentRangeValues.end.toStringAsFixed(2)}',
              ),
              onChanged: (values) {
                setState(() {
                  _currentRangeValues = values;
                });
                widget.onPriceRangeChange(values);
              },
            ),
          ],
        ),
      ),
    );
  }
}