import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  void onSubmit(WidgetRef ref, String value) {
    // тут мы раньше использовали notifier для доступа к другим методам
    // теперь можно оставить запись userChangeNotifierProvider
    ref.read(userChangeNotifierProvider).updateName(value);
  }

  void onSubmitAge(WidgetRef ref, String value) {
    ref.read(userChangeNotifierProvider).updateAge(int.parse(value));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    // здесь у нас нет доступа к пользователю но есть доступ к методам
    // updateName и updateAge, то есть у нас нет доступа к модели пользователя 
    // или к состоянию так сказать 
    // поэтому нужно дописать .user
    // В итоге мы получим доступ к свойствам пользователя
    final user = ref.watch(userChangeNotifierProvider).user;

    // почему риверпод не рекомендует использовать этот тип провайдера
    // потому что возможна следующая запись 
    //* final user = ref.watch(userChangeNotifierProvider).user = const User(name: '', age: 0); *//
    // таким образом мы можем изменить значение пользовательского объекта вне класса
    // и это очень плохо, поэтому риверпод не рекомендует так делать 
    // однако если у вас есть проект в котором используется Provider
    // и он довольно большой в конвертации его в риверпод, то можно использовать этот тип провайдера

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
              onSubmitted: (value) => onSubmit(ref, value),
            ),
            TextField(
              onSubmitted: (value) => onSubmitAge(ref, value),
            ),
            Text(
              user.name,
            ),
          ],
        ),
      ),
    );
  }
}
