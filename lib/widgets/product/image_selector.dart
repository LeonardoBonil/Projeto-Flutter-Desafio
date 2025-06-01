import 'package:flutter/material.dart';

class ImageSelector extends StatefulWidget {
  final String? value;
  final Function(String) onChange;
  final String? error;

  const ImageSelector({
    Key? key,
    this.value,
    required this.onChange,
    this.error,
  }) : super(key: key);

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  String _inputMethod = 'predefined';
  String _customUrl = '';
  final TextEditingController _urlController = TextEditingController();

  final List<Map<String, dynamic>> predefinedImages = [
    {'id': 1, 'url': 'assets/imagem1.jpg', 'name': 'Imagem 1'},
    {'id': 2, 'url': 'assets/imagem2.jpg', 'name': 'Imagem 2'},
    {'id': 3, 'url': 'assets/imagem3.jpg', 'name': 'Imagem 3'},
    {'id': 4, 'url': 'assets/imagem4.jpg', 'name': 'Imagem 4'},
  ];

  @override
  void initState() {
    super.initState();
    _urlController.text = _customUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _handleImageSelect(String imageUrl) {
    widget.onChange(imageUrl);
  }

  void _handleInputMethodChange(String? method) {
    if (method == null) return;

    setState(() {
      _inputMethod = method;
    });

    if (method == 'predefined' &&
        widget.value != null &&
        !predefinedImages.any((img) => img['url'] == widget.value)) {
      widget.onChange(predefinedImages[0]['url']);
    } else if (method == 'url' &&
        predefinedImages.any((img) => img['url'] == widget.value)) {
      widget.onChange('');
      setState(() {
        _customUrl = '';
        _urlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagem do Produto',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Radio(
              value: 'predefined',
              groupValue: _inputMethod,
              onChanged: _handleInputMethodChange,
            ),
            const Text('Imagens predefinidas'),
            const SizedBox(width: 16),
            Radio(
              value: 'url',
              groupValue: _inputMethod,
              onChanged: _handleInputMethodChange,
            ),
            const Text('URL personalizada'),
          ],
        ),
        const SizedBox(height: 16),
        if (_inputMethod == 'predefined')
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: predefinedImages.map((image) =>
                GestureDetector(
                  onTap: () => _handleImageSelect(image['url']),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: widget.value == image['url']
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: widget.value == image['url'] ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            image['url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            image['name'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ).toList(),
          )
        else
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'URL da imagem',
              prefixIcon: const Icon(Icons.cloud_upload),
              errorText: widget.error,
            ),
            onChanged: (url) {
              setState(() {
                _customUrl = url;
              });
              widget.onChange(url);
            },
          ),
        if (widget.value != null && widget.value!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Preview:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _inputMethod == 'predefined'
                    ? Image.asset(
                  widget.value!,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  widget.value!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Text('Erro')),
                ),
              ),
            ],
          ),
      ],
    );
  }
}