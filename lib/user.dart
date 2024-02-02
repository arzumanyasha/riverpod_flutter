import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

@immutable
class User {
  final String name;
  final String email;

  const User({
    required this.name,
    required this.email,
  });

  User copyWith({
    String? name,
    String? email,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(name: $name, email: $email)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}

// на данном этапе можно подумать что всё хорошо и работа сделана, но как правило 
// классы репозитория и классы которые у нас есть можно передать в провайдеры 
// почему именно провайдер?
// потому что любое приложение имет зависимости между классами которые передаются в конструктор
// к примеру у нас может быть UserNotifier который зависит от UserRepository 
// а UserRepository может зависеть в свою очередь от http клиента, который 
// можно взять из констурктора
// Поэтому такие зависимости удобно обрабатывать передавая их в провайдеры
class UserRepository {
  Future<User> fetchUserData() {
    const url = 'http://jsonplaceholder.typicode.com/users/1';
    return http.get(Uri.parse(url)).then((value) => User.fromJson(value.body));
  }
}

// сделаем провайдер для нашего UserRepository
// таким образом если у нас допустим UserRepository содержит 3 зависимых класса в конструкторе
// а его нужно создавать во многих местах приложения то это пустая трата времени
// поэтому и создаются такие пользовательские провайдеры где можно один раз всё передать 
// в конструктор к примеру и мы сможем использовать в коде
// Такие провайдеры полезны при тестировании когда зависимости берутся из конструкторов
// а также провайдер довольно быстро возвращает свой экземпляр
// В противном случае нам нужно будет снова и снова создавать UserRepository
// что будет вызывать пробелмы с памятью
// вместо этого провайдер будет кэшировать наш UserRepository
final userRepositoryProvider = Provider((ref) => UserRepository());
