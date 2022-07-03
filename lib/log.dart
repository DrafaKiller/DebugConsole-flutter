import 'dart:io';

import 'package:flutter/material.dart';

class DebugConsoleLog {
  final String message;
  final DebugConsoleLevel level;
  final DateTime timestamp;
  final StackTrace? stackTrace;

  DebugConsoleLog({
    Object? message,
    this.level = DebugConsoleLevel.normal,
    DateTime? timestamp,
    this.stackTrace,
  }) :
    message = '$message',
    timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return '[$level] $timestamp\n$message\n---${stackTrace != null ? ':' : ''}\n${stackTrace != null ? '${stackTrace ?? ''}---\n' : ''}';
  }

  static List<DebugConsoleLog> fromFile(String filePath) {
    final List<DebugConsoleLog> logs = [];

    final File file = File(filePath);
    if (!file.existsSync()) return logs;

    final RegExp regex = RegExp(
      r'\[(?<level>.*)\] (?<timestamp>.*)\n(?<message>(?:.|\n)*?)\n---(?::\n(?<stackTrace>(?:.|\n)*?)---\n)?',
      multiLine: true,
    );
    final matches = regex.allMatches(file.readAsStringSync());
    for (final match in matches) {
      final String level = match.namedGroup('level') ?? 'normal';
      final String timestamp = match.namedGroup('timestamp') ?? '';
      final String message = match.namedGroup('message') ?? '';
      final String stackTrace = match.namedGroup('stackTrace') ?? '';

      logs.add(DebugConsoleLog(
        message: message,
        level: DebugConsoleLevel.values.firstWhere(
          (DebugConsoleLevel findingLevel) => level.toString() == findingLevel.toString(),
          orElse: () => DebugConsoleLevel.normal,
        ),
        timestamp: DateTime.parse(timestamp),
        stackTrace: stackTrace.isNotEmpty ? StackTrace.fromString(stackTrace) : null,
      ));
    }

    return logs;
  }
}

enum DebugConsoleLevel {
  normal('Normal'),
  info('Info', Colors.lightBlueAccent),
  warning('Warning', Colors.deepOrange),
  error('Error', Colors.redAccent),
  fatal('Fatal', Colors.red),
  debug('Debug', Colors.blue);

  final String name;
  final Color? color;
  const DebugConsoleLevel(this.name, [ this.color ]);

  @override
  String toString() => name;
}