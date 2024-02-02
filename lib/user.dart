import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class User {
  final String name;
  final int age;

  const User({
    required this.name,
    required this.age,
  });

  // метод copyWith позволяет копировать наши свойства
  User copyWith({
    String? name,
    int? age,
  }) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(name: $name, age: $age)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(const User(name: '', age: 0)) ;

  void updateName(String n) {
    state = state.copyWith(name: n);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }
}

// ChangeNotifier класс встроенный во флаттер сдк
// ChangeNotifier предоставляет своим слушателям уведомления об изменении состояния
// которые могут произойти в классе 
// Здесь состояние мы должны создать самостоятельно в отличии от StateNotifier
// в котором можно было нагенерить методы
class UserNotifierChange extends ChangeNotifier {
  // здесь мы рассматриваем пользователя как переменную состояния
  // в классе UserNotifier мы сделали то же самое, однако вместо того чтобы создавать 
  // пользовательскую переменную StateNotifier сделал это за нас
  User user = const User(name: '', age: 0);

  void updateName(String n) {
    user = user.copyWith(name: n);
    // когда этот метод вызовется он уведомит всех клиентов, которые его слушают
    // а его слушает метод ref.watch()
    notifyListeners();
  }

  void updateAge(int age) {
    user = user.copyWith(age: age);
    notifyListeners();
  }
}
