// ignore_for_file: public_member_api_docs, sort_constructors_first
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

// StateNotifier предоставит нам доступ к состоянию переменной, которую можно использовать
// для обновления её данных. Так как нам надо изменять состояние переменных класса User,
// то в качестве возвращаемого типа в StateNotifier передаём наш класс User
class UserNotifier extends StateNotifier<User> {
  // super.state имеет тип User
  //* UserNotifier(super.state); *//

  // 112
  // Тогда конструктор можно переделать следующим образом. Убрать из него состояние (User)
  // вызываем super и в этот super мы и передадим наше состояние
  // здесь мы super вынесли поэтому он будет вызывать родительский класс или унаследованный
  // в нашем случае он вызовет конструктор StateNotifier (потому что мы унаследованы от него)
  // если мы перейдём и посмотрим на конструктор то мы увидим что он принимает состояние -
  // то есть класс User - его мы и передали
  UserNotifier() : super(const User(name: '', age: 0)) ;

  // Здесь String n будет принимать обновлённое значение, когда пользователь будет что-то
  // вводить в текстовое поле
  void updateName(String n) {
    // обращение к состоянию в котором хранится модель User
    // state.name = n; - Ошибка потмоу что поля User являются неизменяемыми 
    // да и вообще сам класс User неизменяемый
    
    // то есть в новое состояние мы копируем все свойства и меняем значение только у свойства name
    state = state.copyWith(name: n);
  }
}
