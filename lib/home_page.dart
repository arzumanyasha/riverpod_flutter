import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/main.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  void onSubmit(WidgetRef ref, String value) {
    // через notifier мы всё также получаем доступ к нашему состоянию 
    // и вызываем метод updateName
    // вся бизнес-логика находится в классе user.dart
    ref.read(userProvider.notifier).updateName(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

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
              user.name,
            ),
          ],
        ),
      ),
    );
  }
}
