import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';
import 'package:window_manager/window_manager.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          DragToMoveArea(
            child: Container(
              height: 50,
              color: Colors.grey,
              child: Center(child: Text('Ввод табельного')),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getButton(number: '1'),
                getButton(number: '2'),
                getButton(number: '3'),
                getButton(number: '4'),
                getButton(number: '5'),
                getButton(number: '6'),
                getButton(number: '7'),
                getButton(number: '8'),
                getButton(number: '9'),
                getButton(number: '0'),

                getButton(
                  number: '⌫',
                  method: () {
                    pressKey(digitsVK['backspace']!);
                  },
                ),

                getButton(
                  number: '↵',
                  method: () {
                    pressKey(digitsVK['enter']!);
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void pressKey(int vk) {
    final input = calloc<INPUT>();

    input.ref.type = INPUT_KEYBOARD;
    input.ref.ki.wVk = VIRTUAL_KEY(vk);

    SendInput(1, input, sizeOf<INPUT>());

    input.ref.ki.dwFlags = KEYEVENTF_KEYUP;
    SendInput(1, input, sizeOf<INPUT>());

    calloc.free(input);
  }

  static const Map<String, int> digitsVK = {
    '0': 0x30,
    '1': 0x31,
    '2': 0x32,
    '3': 0x33,
    '4': 0x34,
    '5': 0x35,
    '6': 0x36,
    '7': 0x37,
    '8': 0x38,
    '9': 0x39,

    'backspace': 0x08,
    'enter': 0x0D,
  };


  Widget getButton({required String number, VoidCallback? method}){

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias, // 👈 важно!
      child: InkWell(
        onTap: method ?? (){
          inputNumbers(number: int.tryParse(number) ?? 0);
        },
        child: SizedBox(
          width: 35,
          height: 50,
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  void inputNumbers ({required int number}) {
    print(number.toString());
    pressKey(digitsVK[number.toString()]!);
  }
}
