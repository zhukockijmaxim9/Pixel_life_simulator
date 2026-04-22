# Разработка

Практический гайд для разработчиков: запуск, сборка, релизы и типичные проблемы.

## Требования

- Flutter SDK установлен и доступен в PATH
- Android Studio / Xcode / Visual Studio (по необходимости, в зависимости от платформы)

Проверка окружения:

```bash
flutter doctor
```

## Установка зависимостей

```bash
flutter pub get
```

## Запуск

### Android / iOS (эмулятор или устройство)

```bash
flutter run
```

### Web

```bash
flutter run -d chrome
```

### Windows (desktop)

```bash
flutter run -d windows
```

## Анализ и тесты

```bash
flutter analyze
flutter test
```

## Сборки

### Android APK

```bash
flutter build apk
```

### Web

```bash
flutter build web
```

### Windows

```bash
flutter build windows
```

## Данные игры и баланс

Контент хранится в `lib/data/`. При изменениях рекомендуется:

- проверить несколько сценариев (дефицит денег, победа/поражение месяца, смена работы),
- убедиться, что новые `id` уникальны (особенно для событий),
- обновить `docs/gameplay.md`, если меняется механика.

## Сохранения и отладка

Сохранение реализовано через `shared_preferences` по ключу `game_state`.

Для “чистого старта” полезно:

- использовать UI-способ сброса (если он предусмотрен),
- или удалить данные приложения на устройстве/эмуляторе.

## FAQ / Troubleshooting

### `flutter pub get` падает

- проверьте интернет/доступ к `pub.dev`
- попробуйте:

```bash
flutter clean
flutter pub get
```

### На Windows не собирается desktop

- убедитесь, что установлен Visual Studio с компонентами “Desktop development with C++”
- проверьте `flutter doctor`

### Ассет не находится (`Unable to load asset`)

- файл не добавлен в `pubspec.yaml`
- путь/регистр букв отличается от фактического
- не был выполнен `flutter pub get` после изменения `pubspec.yaml`

