import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/home_page.dart';
import 'package:riverpod_flutter/logger_riverpod.dart';
import 'package:riverpod_flutter/user.dart';

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider
// ChangeNotifierProvider
// FutureProvider
// StreamProvider

final userFutureProvider =
    FutureProvider.autoDispose.family((ref, String userId) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserData(userId);
}, name: 'Future Provider');

void main() {
  // для того чтобы logger заработал для всего нашего приложения
  // мы должны наш класс LoggerRiverpod добавить в список наблюдателей
  // внутри ProviderScope
  runApp(
    ProviderScope(
      observers: [
        LoggerRiverpod(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
