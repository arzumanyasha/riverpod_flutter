import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/home_page.dart';
import 'package:riverpod_flutter/user.dart';

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider
// ChangeNotifierProvider
// FutureProvider


final fetchUserProvider = FutureProvider((ref) {
  //return UserRepository().fetchUserData();
  final userRepository = ref.watch(userRepositoryProvider);
  // то есть использование метода ref.watch гарантирует что FutureProvider обновиться 
  // когда првоайдер от которого мы зависим - измениться
  // в результате все зависимые виджеты и провайдеры тоже перестрояться
  // таким образом ProviderRef помогает нам взаимодействовать с другим провайдером
  // через ref
  return userRepository.fetchUserData();
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
