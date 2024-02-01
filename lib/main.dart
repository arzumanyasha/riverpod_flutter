import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/home_page.dart';

// Providers
// Provider
// StateProvider

// Все объявленные провайдеры должны быть всегда final, то есть они должны быть неизменяемыми.
// самый простой тип провайдера. Он предоставляет объект который никогда не меняется
// ref - ссылка на провайдер, которая позволит нам общаться с другими провайдерами
// Provider возвращает тип по умолчанию Null если мы туда ничего не передадит (= return null;)
// тип провайдера можно также явно указать, Provider<String> например
// Это глобальный провайдер, поэтому мы можем его прочитать в любом файле
// Провайдер доступен только для чтения
// можно использовать например для доступа к репозиторию или чтению логов

// Есть 3 способа прочитать наш nameProvider
final nameProvider = Provider((ref) {
  return 'Privet';
});

// а что если мы хотим менять значение провайдера?
// для этого есть StateProvider который отлично подходит для хранения простых объектов состояния,
// которые могут изменятся извне
final nameStateProvider = StateProvider<String?>((ref) => null);
// null изначально возвращаемое значение

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
