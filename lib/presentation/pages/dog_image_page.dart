import 'package:flutter/material.dart';
import 'package:app_cani/domain/usecases/get_random_dog_image.dart';
import 'package:app_cani/domain/entities/dog_image.dart';

class DogImagePage extends StatefulWidget {
  final GetRandomDogImage getRandomDogImage;

  const DogImagePage({super.key, required this.getRandomDogImage});

  @override
  State<DogImagePage> createState() => _DogImagePageState();
}

class _DogImagePageState extends State<DogImagePage> {
  DogImage? _currentDogImage;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRandomDogImage();
  }

  Future<void> _loadRandomDogImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dogImage = await widget.getRandomDogImage();
      setState(() {
        _currentDogImage = dogImage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore nel caricamento dell\'immagine: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Dog Images'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _loadRandomDogImage,
        icon: const Icon(Icons.refresh),
        label: const Text('Nuovo Cane'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Caricamento...'),
        ],
      );
    }

    if (_errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadRandomDogImage,
            child: const Text('Riprova'),
          ),
        ],
      );
    }

    if (_currentDogImage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _currentDogImage!.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 64),
                        SizedBox(height: 8),
                        Text('Errore nel caricamento dell\'immagine'),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '🐕 Premi il pulsante per vedere un altro cane! 🐕',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return const Text('Nessuna immagine disponibile');
  }
}
