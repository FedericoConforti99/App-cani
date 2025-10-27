import 'package:app_cani/domain/entities/dog_image.dart';

/// Model per la risposta dell'API Dog CEO
class DogImageModel extends DogImage {
  DogImageModel({
    required super.imageUrl,
    required super.status,
  });

  /// Factory per creare un DogImageModel da JSON
  factory DogImageModel.fromJson(Map<String, dynamic> json) {
    return DogImageModel(
      imageUrl: json['message'] as String,
      status: json['status'] as String,
    );
  }

  /// Converte il model in JSON
  Map<String, dynamic> toJson() {
    return {
      'message': imageUrl,
      'status': status,
    };
  }
}
