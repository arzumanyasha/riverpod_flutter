import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_flutter/home_page.dart';
import 'package:riverpod_flutter/user.dart';

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider
// ChangeNotifierProvider
// FutureProvider
// StreamProvider

// с помощью модификатора family мы можем передать параметр в сам провайдер
// таким образом этот параметр можно свободно использовать в нашем првоайдере
// для создания некоторого состояния
// family позволяет передать только один параметр в провайдер причём
// передаваемый параметр должен быть либо примитивным, либо константой,
// либо неизменяемым объектом у которого мы должны переопределить == и hashcode
// и поэтому чтобы обойти такое ограничение с параметрами - используется 
// пакет tuple - он же кортеж, с помощью которого мы можем создать
// на основе кортежа например 3 типа параметров и инкапсулировать их
// в один параметр и уже его передать провайдеру 
// Также мы можем передать любой пользовательский объект,
// который реализует hashcode и ==
// к примеру объекты созданные с помощью freezed или пакета equitable
// Также чтобы можно было обойти ограничение с параметрами 
// можно использовать новый пакет riverpod_generator
// и с помощью данного пакета можно передать столько именованных и позиционных
// параметров сколько хотим

// autodispose - этот модификатор позволяет автоматически удалять состояние 
// провайдера когда оно больше не используется а также избежать утечки памяти
// autodispose реализован у всех типов провайдеров
// его следует использовать до передачи параметров
// ПРОВАЙДЕРЫ КЕШИРУЮТ СВОЁ СОСТОЯНИЕ
// например если мы передадим в параметр сперва 1 потом 4 (на этом этапе будет новый провайдер)
// потом снова 1 то значение полученное по userId == 1 выдастся сразу потому что 
// этот првоайдер по умолчанию закеширует значение ответа
// поэтому после использования autoDispose провайдер будет автоматически удалён
// после удаления всех его слушаетелей, то есть где ref.watch, ref.listen

// также autoDispose можно использовать без модификатора family 
final userFutureProvider = FutureProvider.autoDispose.family((ref, String userId) {
  // когда мы используем модификатор dispose то нам доступен метод keepAlive
  // этот метод сообщает провайдеру чтобы он сохранял состояние на неопределённый срок 
  // в результате чего провайдер будет обновляться только в том случае если мы обновим
  // или аннулируем его
  ref.keepAlive();
  // есть ещё другие полезные методы
  // ref.onAddListener с помощью этого методы мы можем добавить слушателей к нашему провайдеру
  ref.onAddListener(() { });
  // либо с помощью onRemoveListener - этих слушателей удалить
  ref.onRemoveListener(() { });
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserData(userId);
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
