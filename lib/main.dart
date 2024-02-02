import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/home_page.dart';
import 'package:riverpod_flutter/user.dart';

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider

// в качестве первого возвращаемого типа мы сначала передадим UserNotifier
// а в качестве второго типа мы передадим состояние класса UserNotifier - то есть User
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  //* return UserNotifier(const User(name: '', age: 0)); *//
  // Допустим мы не хотим передавать в UserNotifier какое-либо состояние 
  // то есть оставим конструктор пустым. Продолжение модификаций в классе User 
  // пометка 112
  return UserNotifier();
});

// у нас есть класс User. Допустим в этой модели мы хотим поменять значения у этих 2 свойств
// да, можно конечно обновить состояние этих двух свойств с помощью StateProvider
// но тогда наша логика будет находится в общих виджетах homa_page
// а такого не хотелось бы да и в реальном мире свойств всегда гораздо больше 
// Решение - улучшенная версия StateProvider - комбинация StateNotifier & StateNotifierProvider
// они идеально подходят для управления состоянием, которое может измениться в ответ на событие 
// или взаимодействие с пользователем

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
