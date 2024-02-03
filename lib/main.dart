import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_flutter/home_page.dart';
import 'package:riverpod_flutter/logger_riverpod.dart';
import 'package:riverpod_flutter/user.dart';

// так как мы будем запускать генератор кода то сгенереный код нам надо где-то разместить в файле
// то есть когда мы запустим build runner то автоматически создасться файл с таким названием
// который и будет содержать сгенерированный код для нашего првоайдера
// чтобы сгенерить файл  - запустим в терминале flutter pub run build_runner watch
// такие файлы создаются вместе с существующими файлами
// поэтому нам не нужно менять структуру папок
// благодаря watch билд раннер может видить изменения и в случае чего
// сразу же заново запускать кодогенерацию
part 'main.g.dart';

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider
// ChangeNotifierProvider
// FutureProvider
// StreamProvider

// зададит себе такой вопрос: должны ли мы писать провайдеры вручную
// с одной стороны у нас могу быть простые првоайдеры
// final nameProvider = Provider((ref) => 'Artur');
// а с другой стороны некоторые провайдеры могут иметь зависимости от других провайдеров
// а также могут принимать параметры с помощью модификатора family
// Выглядит не очень читабельно да и есть ограничения у модификатора family
// а также написание большого количества провайдеров вручную может быть
// подвержено ошибкам, да и выбрать какой провайдер использовать - не всегда просто
// поэтому автор риверпода представил новый синтаксис и новое апи
// для генерации провайдеров на лету реализовав всё в пакете riverpod generator

// пакет использует генерацию кода поэтому мы подключаем ещё пакет build runner
// riverpod_annotation - дополнительный пакет для риверпод генератора
// который предоставляет аннотации

// таким образом мы преобразовани провайдер в обычный метод и данный метод должен быть глобальным
// здесь мы ссначала указываем возвращаемый тип (String), далее мы указываем имя метода (name)
// после слова name слово provider можно не писать.
// После генерации пакет автоматически его добавит
// далее указываем требуемые параметры (NameRef ref). То есть ссылку на провайдер
// Обычно здесь пишут название метода + Ref. Далее уже реализовывается тело метода
// метод мы также помечает аннотацией риверпода
@riverpod
String name(NameRef ref) {
  return 'Artur';
}

// таким образом благодаря пакету генератора мы можем передавать
// столько параметров сколько захотим
// можем эти параметры делать именованными или позиционными как хотим, но первый всгда позиционный
@riverpod
Future<User> fetchUser(
  FetchUserRef ref, {
  required String userId,
  required int intValue,
  required bool boolValue,
}) {
  log('init: fetchuser($userId)');

  ref.onCancel(() => log('cancel: fetchuser($userId)'));
  ref.onResume(() => log('resume: fetchuser($userId)'));
  ref.onDispose(() => log('dispose: fetchuser($userId)'));

  final link = ref.keepAlive();

  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
  });

  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 10), () => link.close());
  });

  ref.onResume(() {
    timer?.cancel();
  });

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserData(userId);
}

// final userFutureProvider =
//     FutureProvider.autoDispose.family((ref, String userId) {
//   final userRepository = ref.watch(userRepositoryProvider);
//   return userRepository.fetchUserData(userId);
// }, name: 'Future Provider');

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
