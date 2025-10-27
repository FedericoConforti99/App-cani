import 'package:app_cani/domain/entities/dog_image.dart';
import 'package:app_cani/domain/repositories/dog_repository.dart';

/// Use Case per ottenere un'immagine random di un cane
class GetRandomDogImage {
  final DogRepository repository;

  GetRandomDogImage(this.repository);

  /// Esegue lo use case
  Future<DogImage> call() async {
    return await repository.getRandomDogImage();
  }
}
