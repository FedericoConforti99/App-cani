import 'package:app_cani/data/datasources/dog_remote_data_source.dart';
import 'package:app_cani/domain/entities/dog_image.dart';
import 'package:app_cani/domain/repositories/dog_repository.dart';

/// Implementazione del DogRepository
class DogRepositoryImpl implements DogRepository {
  final DogRemoteDataSource remoteDataSource;

  DogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DogImage> getRandomDogImage() async {
    try {
      final dogImageModel = await remoteDataSource.getRandomDogImage();
      return dogImageModel;
    } catch (e) {
      throw Exception('Error fetching random dog image: $e');
    }
  }
}
