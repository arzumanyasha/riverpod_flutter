import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/home_page.dart';
import 'package:riverpod_flutter/user.dart';
import 'package:http/http.dart' as http;

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider
// ChangeNotifierProvider
// FutureProvider


// по умолчанию возвращает тип null
// FutureProvider возвращает тип Response хотя наш гет запрос возвращает Future<Response>
// поскольку мы находимся в провайдере то он просто проигнорирует Fututre 
// и вернёт нам Response проинкапсулировнном в FutureProvider

// Смысла обрабатывать ошибки через встраивание в цепочку в конце .catchError() 
// не имеет смысла так как FutureProvider является лучшей заменой FutureBuilder'a
// и всё будем улавливать в пользовательском интерфейсе
final fetchUserProvider = FutureProvider((ref) {
  const url = 'http://jsonplaceholder.typicode.com/users/1';
  return http.get(Uri.parse(url)).then((value) => User.fromJson(value.body));
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
