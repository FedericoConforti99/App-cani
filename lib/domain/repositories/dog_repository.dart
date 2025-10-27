import 'package:app_cani/domain/entities/dog_image.dart';

/// Repository interface per le operazioni sui cani
abstract class DogRepository {
  /// Ottiene un'immagine random di un cane
  Future<DogImage> getRandomDogImage();
}
