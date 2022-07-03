import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:debug_console/debug_console.dart';

void main() {
  DebugConsole.listen(() {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DebugConsolePopup(
          child: Scaffold(
            body: Center(
              child: Text('Hello World'),
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () async {
      print('Hello World');
      await Future.delayed(const Duration(milliseconds: 2000));
      DebugConsole.debug('Debug message');
      await Future.delayed(const Duration(milliseconds: 1500));
      DebugConsole.error('Error message, with StackTrace', stackTrace: StackTrace.current);
      await Future.delayed(const Duration(milliseconds: 1500));
      availableCameras().then((cameras) => CameraController(cameras.first, ResolutionPreset.medium));
    });
  });
}