import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String userId = '1';

  @override
  Widget build(BuildContext context) {
    // теперь наш провайдер поход на метод в который мы можем передать userID
    final user = ref.watch(userFutureProvider(userId));
    return user.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Title'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  onSubmitted: (value) {
                    userId = value;
                    // ТОЛЬКО ДЛЯ ПРИМЕРА
                    setState(() {});
                  },
                ),
                Text(
                  data.toString(),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        // тут мы можем получить ошибку и её обработать + получить трассирвоку
        return Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        );
      },
      loading: () {
        // тут можно отобразить индикатор загрузки
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
