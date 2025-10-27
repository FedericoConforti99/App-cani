import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_cani/data/datasources/dog_remote_data_source.dart';
import 'package:app_cani/data/repositories/dog_repository_impl.dart';
import 'package:app_cani/domain/usecases/get_random_dog_image.dart';
import 'package:app_cani/presentation/pages/dog_image_page.dart';

void main() {
  // Dependency Injection (manuale per semplicità)
  final httpClient = http.Client();
  final remoteDataSource = DogRemoteDataSourceImpl(client: httpClient);
  final repository = DogRepositoryImpl(remoteDataSource: remoteDataSource);
  final getRandomDogImage = GetRandomDogImage(repository);

  runApp(MyApp(getRandomDogImage: getRandomDogImage));
}

class MyApp extends StatelessWidget {
  final GetRandomDogImage getRandomDogImage;

  const MyApp({super.key, required this.getRandomDogImage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Images App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: DogImagePage(getRandomDogImage: getRandomDogImage),
    );
  }
}
