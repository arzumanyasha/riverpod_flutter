import 'dart:async';
import 'dart:developer';

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
// StreamProvider

 
final userFutureProvider = FutureProvider.autoDispose.family((ref, String userId) {
  
  log('init: fetchuser($userId)');

  ref.onCancel(() => log('cancel: fetchuser($userId)'));
  ref.onResume(() => log('resume: fetchuser($userId)'));
  ref.onDispose(() => log('dispose: fetchuser($userId)'));

  // реализуем кеширование состояния с таймаутом
  // в первую очередь нам надо получить ссылку на сохранение состояния
  final link = ref.keepAlive();
  // далее нам надо реализовать таймер по истечении времени которого 
  // мы будем удалять кеш состояния
  Timer? timer;

  ref.onDispose(() { 
    // в этом методе мы можем отменять различные подписки, таймеры 
    // также можно отменять разные http запросы если у нас FutureProvider
    // если у нас например StreamProvider то мы можем отменять подписки на потоки
    // на которые подписывались ранее и тд

    // конкретно в этом методе мы будет отписываться от таймера
    // когда состояние провайдера будет удалено 
    timer?.cancel();
  });

  ref.onCancel(() { 
    // в этом методе мы будем запускать таймер для удаления закеширвоанных данных
    // после того как мы перестанем слушать провайдер
    // В каком плане: значит при запуске приложения мы получаем юзера с айди 1
    // и создаётся первый провайдер, потом просим отобразить пользователя с айди 2
    // в итоге созданный провайдер для пользователя с айди 1 мы уже не слушаем
    // а слушаем новый созданный провайдер для пользователя с айди 2
    // так вот когда мы перестаём слушать провайдер - будет запускаться метод onCancel
    // с нашим таймером чтобы первый провайдер не сохранялся долго в памяти приложения
    // другими словами метод onCancel срабатывает при удалении последнего слушателя провайдера
    timer = Timer(const Duration(seconds: 10), () => link.close());
  });

  ref.onResume(() { 
    // реализуем метод onResume в котором также будет отменять таймер
    // метод onResume срабатывает когда провайдер снова начинают прослушивать 
    // поэтому здесь мы и отменяем время чтобы кэш нашего состояния не удалился 
    timer?.cancel();
  });

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserData(userId);
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
