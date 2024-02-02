import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  void onSubmit(WidgetRef ref, String value) {
    ref.read(userProvider.notifier).updateName(value);
  }

  void onSubmitAge(WidgetRef ref, String value) {
    ref.read(userProvider.notifier).updateAge(int.parse(value));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // сейчас метод ref.watch() перезапускает всё дерево виджетов в методе build()
    // всякий раз когда меняется значение этого пользователя
    // то есть если измениться значение у свойства name, то перестрйока всех виджетов 
    // выполниться повторнов методе build
    // то же самое произойдёт если поменяется age

    // но что если мы хотим запускать перестроение дерева виджетов только при изменении
    // определённого свойства класса User? допустим изменение name
    //* final user = ref.watch(userProvider); *//

    // то тут нам поможет метод select который реализован у каждого пользовательского провайдера
    // можно сказать что метод select используется как фильтр и служит для прослушивания только
    // определённого свойства
    final name = ref.watch(userProvider.select((value) => value.name));

    // Как мы уже знаем для наблюдения за состоянием провайдера мы используем метод watch(),
    // однако кроме этого есть метод listen()

    // Главная разница между методом ref.watch() и ref.listen() заключается в том что метод listen
    // не перестраивает виджет или провайдер, а вызывает определённый метод
    // когда меняется состояние у провайдера. К примеру мы можем показать диалоговое окно с ошибкой
    // или snackbar, которое отразит изменение состояния в провайдере

    // ref.listen() принимает 2 параметра, 1 - прослушиваемый провайдер и 2 - метод listener
    // 2-й параметр это метод, который должен вызываться при изменении значения провайдера
    // причём метод должен принимать 2 параметра:
    // 1) предыдущее состояние - previous
    // 2) и новое состояние провайдера - next

    // колбэк listener() выполняется при изменении значения провайдера а не при вызове build
    // следовательно мы можем его использовать также для запуска любого асинхронного кода
    // например для отображения оповещения или осуществить навигацию и тд
    // метод listen не стоит использовать внутри методов initState и других методов жц
    ref.listen(
      // благодаря этому селекту метод listen вызывается только при изменении age
      userProvider.select((value) => value.age),
      (previousState, currentState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Our age was $previousState and the new age $currentState',
            ),
          ),
        );
      },
    );

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
              name,
            ),
          ],
        ),
      ),
    );
  }
}
