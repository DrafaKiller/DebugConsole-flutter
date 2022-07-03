import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:debug_console/log.dart';

class DebugConsoleController {
  final List<DebugConsoleLog> logs;
  final _streamController = BehaviorSubject<List<DebugConsoleLog>>();

  DebugConsoleController({ List<DebugConsoleLog>? logs }) : logs = logs ?? [];

  Stream<List<DebugConsoleLog>> get stream => _streamController.stream;

  void close() => _streamController.close();
  void notifyUpdate() => _streamController.add(logs);

  void log(
    Object? message, {
    DebugConsoleLevel level = DebugConsoleLevel.normal,
    DateTime? timestamp,
    StackTrace? stackTrace,
  }) {
    logs.add(
      DebugConsoleLog(
        message: message,
        level: level,
        timestamp: timestamp,
        stackTrace: stackTrace,
      )
    );
    notifyUpdate();
  }

  List<DebugConsoleLog> getLogsByLevel(DebugConsoleLevel level) {
    return logs.where((log) => log.level == level).toList();
  }

  void clear() {
    logs.clear();
    notifyUpdate();
  }
}