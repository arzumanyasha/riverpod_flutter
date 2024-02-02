import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // возвращается AsyncValue - что я вляется улучшенной версией асинхронного снимка
    // или AsyncSnapshot у FutureBuilder
    final user = ref.watch(fetchUserProvider);

    // user.asData - возвращает AsyncData а хотелось бы напрямую получить доступ к данным
    // или доступ к ошибкам для их обработки поэтому мы применяем следующую запись ниже.
    // метод when использует pattern matching или шаблон сопоставления с образцом
    // чтобы сопоставить результат AsyncValue (data, error, loading) с нашим польз-им инт-ом
    // и эти состояния уже взаимосвязаны между собой

    // если мы не хотим обрабатывать ошибки или loading то можно юзать метод .whenData()
    // также есть метод .map который возвращает не прямые данные а асинхронные (AsyncData etc.)
    return user.when(
      data: (data) {
        // тут мы получаем простые данные которые мы можем отобразить на экране
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
                  data.name,
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

    // реализация FutureBuilder
    // AsyncSnapshot позволяет обрабатывать ConnectionState, данные, ошибка
    // Асинхронный снимок предполагает что все эти состояния не взаимосвязаны
    // друг с другом, они независимы друг от друга
    // ну хотя hasData и hasError вроде как имеют связь между собой
    // Так что это не самый чистый способ обработки состояния
    // Но при использовании AsyncValue это можно сделать лучше и правильнее

    // return FutureBuilder(
    //     future: future,
    //     initialData: initialData,
    //     builder: ((context, snapshot) {
    //       // Если данные ещё не поступили в snapshot
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         // Здесь отображаем индикатор загрузки
    //       }

    //       // затем првоеряем есть ли данные в Snapshot
    //       if (snapshot.hasData) {
    //         // если данные есть, то отображаем их
    //       } else {
    //         // если нет, то что-нибудь отображаем
    //       }
    //       // затем првоеряем содержит ли snapshot ошибку
    //       if (snapshot.hasError) {
    //         // если да то отображаем её
    //       }
    //       return;
    //     }));
  }
}
