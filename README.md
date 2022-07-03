[![Pub.dev package](https://img.shields.io/badge/pub.dev-debug__console-blue)](https://pub.dev/packages/debug_console)
[![GitHub repository](https://img.shields.io/badge/GitHub-DebugConsole--flutter-blue?logo=github)](https://github.com/DrafaKiller/DebugConsole-flutter)

# Debug Console

A console for debugging Flutter apps, and displaying console messages on the widget.

Check the console for prints and errors, while you're testing it, all within your app. Make your own logging or watch for console prints.

## Features

* Log your messages
* Display console messages and errors
* Use different levels for better emphasis
* Filter the logs
* Add extra actions to execute from the Debug Console menu
* Check StackTrace of errors

## Getting started

Install it using pub:
```
flutter pub add debug_console
```

And import the package:
```dart
import 'package:debug_console/debug_console.dart';
```

## Usage

A console can be created using the widget `DebugConsole`.

Each log message displays a timestamp, level, and stack trace, if available.

You can control the consoles using a `DebugConsoleController`, you can create your own to isolate a console from the others, or you can use the root, `DebugConsole.instance`.

```dart
final controller = DebugConsoleController();

controller.log('Hello World', level: DebugConsoleLevel.info);
print(controller.logs); // List<DebugControllerLog>
controller.clear();

DebugConsole.log('Hello World', level: DebugConsoleLevel.info);
DebugConsole.clear();

DebugConsole.info('Info message');
// Also: warning, error, fatal, debug
```

Log a message with a StackTrace, doesn't need to be an error, it works with any level.

```dart
DebugConsole.error('Error message', stackTrace: StackTrace.current);
```

### Listen for Prints and Errors

To catch all messages in your app, you need to use `DebugConsole.listen` to listen for prints and errors.

Everything inside that function will be automatically logged.

```dart
DebugConsole.listen(() {
  runApp(const MyApp());
});
```

* A controller can be given, instead of logging to the root.

### Debug Console Popup

Run your app along with the Debug Console using the popup. Click the floating debug icon to open the console.

```dart
MaterialApp(
  home: DebugConsolePopup(
    showButton: true,
    child: ...
  );
);
```

### Save logs to a file

In case you need the save the logs, when setting the `savePath` argument, it will automatically save all the logs to that file.

```dart
DebugConsole(
  savePath: 'debug_console.log',
);
```

For some platforms, using files can be a little bit more tricky:

* When debugging on a desktop, like Windows, simple paths can be used to create a log file in the project folder.

* When debugging on a mobile device, like Android and iOS, you need to use a storage/temporary path, the log files will stay on the device.

The Debug Console can automatically load the logs, using `DebugConsole.loadPath`, which should be set before using `DebugConsole.instance`. You can also manually load the logs when creating a controller.

### Menu Actions

Actions can be added to the Debug Console to execute whenever needed from the menu.

```dart
DebutConsole(
  actions: [
    PopupMenuItem(
      onTap: () => print('test'),
      child: const Text('Print test'),
    ),
  ]
);
```