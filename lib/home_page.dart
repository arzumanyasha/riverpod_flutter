import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // поток возвращает AsyncValue
    final streamNumber = ref.watch(streamProvider);
    // обработка состояния в стрим провайдере происходит точно так как и в FutureProvider
    // таким орбазом StreamProvider заменяет собой StreamBuilder, что даёт свои преимущества
    // например гарантию правильной обработки состояний в случае загрузки или ошибок
    // благодаря возвращаемому AsyncValue.
    return streamNumber.when(
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
