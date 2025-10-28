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
  DogImage? _cachedDogImage; // Immagine precaricata in cache
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialImages();
  }

  /// Carica la prima immagine e precarica subito la seconda
  Future<void> _loadInitialImages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Carica la prima immagine da mostrare
      final firstImage = await widget.getRandomDogImage();
      
      // Precarica già la seconda immagine in cache
      final secondImage = await widget.getRandomDogImage();
      
      setState(() {
        _currentDogImage = firstImage;
        _cachedDogImage = secondImage;
        _isLoading = false;
      });

      // Precarica l'immagine in cache per Flutter
      if (_cachedDogImage != null) {
        _precacheImage(_cachedDogImage!.imageUrl);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore nel caricamento dell\'immagine: $e';
        _isLoading = false;
      });
    }
  }

  /// Mostra l'immagine dalla cache e precarica la prossima
  Future<void> _showNextDogImage() async {
    if (_cachedDogImage == null) {
      // Fallback: se non c'è cache, carica normalmente
      await _loadRandomDogImage();
      return;
    }

    // Usa l'immagine dalla cache
    final nextImage = _cachedDogImage;
    
    setState(() {
      _currentDogImage = nextImage;
      _cachedDogImage = null; // Reset della cache
    });

    // Precarica la prossima immagine in background
    _preloadNextImage();
  }

  /// Precarica la prossima immagine in background
  Future<void> _preloadNextImage() async {
    try {
      final nextImage = await widget.getRandomDogImage();
      setState(() {
        _cachedDogImage = nextImage;
      });
      
      // Precarica l'immagine per Flutter
      if (_cachedDogImage != null) {
        _precacheImage(_cachedDogImage!.imageUrl);
      }
    } catch (e) {
      // Ignora errori nel precaricamento in background
      debugPrint('Errore nel precaricamento: $e');
    }
  }

  /// Precarica l'immagine nella cache di Flutter
  void _precacheImage(String imageUrl) {
    precacheImage(NetworkImage(imageUrl), context);
  }

  /// Carica un'immagine random (usato come fallback)
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
      
      // Dopo aver caricato, precarica la prossima
      _preloadNextImage();
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
            onPressed: _loadInitialImages,
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _showNextDogImage,
              icon: const Text('🐕', style: TextStyle(fontSize: 24)),
              label: const Text(
                'Nuovo Cane',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const Text('Nessuna immagine disponibile');
  }
}
