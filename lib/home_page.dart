import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

// 1-й способ прочитать провайдер - ConsumerWidget
// ConsumerWidget заменяет StatelessWidget, что даёт нам возможность читать и изменять состояние провайдера
// а также просулшивать их
// С помощью ref мы сможем наблюдать за значением проавйдера используя ref объекта типа WidgetRef
// WidgetRef - объект позволяющий виджетам взаимодействовать с провайдерами.
// Есть некоторое сходство между BuildContext и WidgetRef
// BuildContext позволяет нам получить доступ к виджетам предкам в дереве виджетов таким как:
// Theme.of(context) и MediaQuery.of(context)
// А WidgetRef позволяет нам получить доступ к любому провайдеру внутри нашего приложения
// Это сделано специально потому что все провайдеры в риверпод являются глобальными.
// Это важно потому что сохранение состояния и логики приложения внутри наших виджетов
// приводит к плохому разделению задач, а перемещение состояния внутрь наших провайдеров
// делает наш код более тестируемым и удобным в сопровождении
class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // получение значения из нашего провайдера
    final name = ref.watch(nameProvider);

    // также можно прочитать значение из провайдера используя метод read()
    // разница в том что метод read() вызывается только один раз.
    // Его обычно используют в методах initState или других методах жц приложения
    // или в кнопках, где мы например можем нажать на кнопку и получим значение из провайдера
    // Однако если мы хотим постоянно слушать провайдер, чтобы узнать есть ли какие изменения в нём или их нет,
    // то мы можем использовать метод watch(). Его рекомендуют использовать в методе build()
    // не стоит использовать метод watch() в кнопках
    //* final nameRead = ref.read(nameProvider); *//

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
              name,
            ),
          ],
        ),
      ),
    );
  }
}

// 2-й способ
// в качестве альтернативы мы можем обернуть виджет Text в виджет Consumer и у этого виджета
// мы должны реализовать метод builder, который принимает 3 параметра (context, ref, child)
// Когда мы должны использовать Consumer вместо ConsumerWidget?
// как можно заметить, при использовании Consumer мы оборачиваем только виджет а не всего родителя
// В результате перестроение виджета Text будет происходить только при изменении значения провайдера
// Это может показаться мелочью но если у нас есть большой класс виджетов со сложной компоновкой,
// то с помощью Consumer мы можем перестраивать только ту область виджетов которая зависит от провайдера
// А если мы будем создавать небольшие многоразовые виджеты, то лучше использовать ConsumerWidget
// Тем более создание небольших многоразовых виджетов способствует композиции,
// что приводит к созданию лаконичного и производительного кода
// ConsumerWidget является хорошей заменой StatelessWidget и даёт нам удобный способ доступа
// к провайдерам с минимальным кодом
class MyHomePage1 extends StatelessWidget {
  const MyHomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                // через ref мы можем прочитать значение из провайдера
                final name = ref.watch(nameProvider);
                return Text(
                  name,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 3-й способ
// здесь в метод build нам не нужно передавать WidgetRef как это было с ConsumerWidget
// ref уже встроен в виджет ConsumerStatefulWidget
class MyHomePage2 extends ConsumerStatefulWidget {
  const MyHomePage2({super.key});

  @override
  ConsumerState<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends ConsumerState<MyHomePage2> {
  @override
  void initState() {
    super.initState();
    // если нам например надо прочитать значение в одном из методов ЖЦ
    //* final name = ref.read(nameProvider); *//
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(name),
          ],
        ),
      ),
    );
  }
}

class MyHomePage4 extends ConsumerWidget {
  const MyHomePage4({super.key});

  void onSubmit(WidgetRef ref, String value) {
    // у такого типа провайдеров есть свойство notifier,
    // которое предоставляет доступ к новым методам
    // метод update содержит state - это текущее состояние нашего провайдера
    ref.read(nameStateProvider.notifier).update((state) => value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameStateProvider) ?? '';

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
            Text(
              name,
            ),
          ],
        ),
      ),
    );
  }
}
