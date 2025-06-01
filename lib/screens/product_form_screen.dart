import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<String> categories = [
    'Eletrônicos',
    'Informática',
    'Áudio',
    'Casa e Jardim',
    'Roupas',
    'Livros',
    'Esportes',
    'Saúde e Beleza',
    'Automóveis',
    'Brinquedos',
    'Outros'
  ];

  final List<Map<String, dynamic>> localImages = [
    {'id': 1, 'url': 'assets/imagem1.jpg', 'name': 'Imagem 1'},
    {'id': 2, 'url': 'assets/imagem2.jpg', 'name': 'Imagem 2'},
    {'id': 3, 'url': 'assets/imagem3.jpg', 'name': 'Imagem 3'},
    {'id': 4, 'url': 'assets/imagem4.jpg', 'name': 'Imagem 4'},
  ];

  late Map<String, dynamic> formData;
  String? imagePreview;

  @override
  void initState() {
    super.initState();
    formData = {
      'id': widget.product?['id'],
      'name': widget.product?['name'] ?? '',
      'description': widget.product?['description'] ?? '',
      'price': widget.product?['price']?.toString() ?? '',
      'stock': widget.product?['stock']?.toString() ?? '',
      'category': widget.product?['category'] ?? '',
      'imageUrl': widget.product?['imageUrl'] ?? '',
    };
    imagePreview = formData['imageUrl'];
  }

  void _handleSelectLocalImage(String imageUrl) {
    setState(() {
      imagePreview = imageUrl;
      formData['imageUrl'] = imageUrl;
    });
  }

  void _handleRandomImage() {
    final randomImage = localImages[DateTime.now().millisecondsSinceEpoch % localImages.length];
    _handleSelectLocalImage(randomImage['url']);
  }

  void _handleRemoveImage() {
    setState(() {
      imagePreview = null;
      formData['imageUrl'] = '';
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ProductProvider>();

      // Converte valores para o formato correto
      final productData = {
        ...formData,
        'price': double.parse(formData['price']),
        'stock': int.parse(formData['stock']),
      };

      if (widget.product != null) {
        await provider.updateProduct(productData);
      } else {
        await provider.addProduct(productData);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar produto: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.product != null ? 'Editar Produto' : 'Novo Produto'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo de Nome
                  TextFormField(
                    initialValue: formData['name'],
                    decoration: const InputDecoration(
                      labelText: 'Nome do Produto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório';
                      }
                      return null;
                    },
                    onSaved: (value) => formData['name'] = value,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Descrição
                  TextFormField(
                    initialValue: formData['description'],
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onSaved: (value) => formData['description'] = value,
                  ),
                  const SizedBox(height: 16),

                  // Campos de Preço e Estoque em Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: formData['price'],
                          decoration: const InputDecoration(
                            labelText: 'Preço',
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ ',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Preço é obrigatório';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Preço inválido';
                            }
                            return null;
                          },
                          onSaved: (value) => formData['price'] = value,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: formData['stock'],
                          decoration: const InputDecoration(
                            labelText: 'Estoque',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Estoque é obrigatório';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Estoque inválido';
                            }
                            return null;
                          },
                          onSaved: (value) => formData['stock'] = value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Campo de Categoria (Dropdown)
                  DropdownButtonFormField<String>(
                    value: formData['category'].isEmpty ? null : formData['category'],
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        formData['category'] = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Categoria é obrigatória';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Seleção de Imagem
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Imagem do Produto',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: imagePreview != null && imagePreview!.isNotEmpty
                            ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              imagePreview!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Text('Erro ao carregar imagem')),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: _handleRemoveImage,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                            : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _handleRandomImage,
                                child: const Text('Selecionar Imagem'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(widget.product != null ? 'Atualizar' : 'Criar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}