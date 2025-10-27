import 'dart:convert';
import 'package:app_cani/data/models/dog_image_model.dart';
import 'package:http/http.dart' as http;

/// Data Source per recuperare dati dall'API Dog CEO
abstract class DogRemoteDataSource {
  /// Ottiene un'immagine random di un cane dall'API
  Future<DogImageModel> getRandomDogImage();
}

class DogRemoteDataSourceImpl implements DogRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://dog.ceo/api';

  DogRemoteDataSourceImpl({required this.client});

  @override
  Future<DogImageModel> getRandomDogImage() async {
    final response = await client.get(
      Uri.parse('$baseUrl/breeds/image/random'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return DogImageModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load dog image: ${response.statusCode}');
    }
  }
}
