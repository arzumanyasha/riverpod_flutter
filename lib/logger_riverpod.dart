import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggerRiverpod extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    // данный метод даёт доступ на мониторинг предыдущего и нового значения в провайдере
    // в этом же методе можно сделать првоерку на тип
    super.didUpdateProvider(provider, previousValue, newValue, container);
    log('${provider.name ?? provider.runtimeType}, $previousValue, $newValue');
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    // данный метод вызывается каждый раз когда мы инициализируем провайдер
    // а отображаемое значение это value
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    // данный метод вызывается каждый раз когда провайдер удаляется
    super.didDisposeProvider(provider, container);
  }
}