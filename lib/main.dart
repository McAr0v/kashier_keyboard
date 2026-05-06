import 'package:flutter/material.dart';
import 'package:kashier_keyboard/keyboard.dart';
import 'package:win32/win32.dart';
import 'package:window_manager/window_manager.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(720, 150),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    // 👇 ВАЖНО: минимальный размер
    await windowManager.setMinimumSize(const Size(720, 150));
    // 🔥 ВОТ РЕАЛЬНЫЙ ФИКС
    final hwnd = GetForegroundWindow();

    final exStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE).value;

    SetWindowLongPtr(
      hwnd,
      GWL_EXSTYLE,
      exStyle |
      WS_EX_NOACTIVATE |
      WS_EX_TOOLWINDOW,
    );

  });

  runApp(
      MaterialApp(
        home: const Keyboard(),
      )
  );
}

