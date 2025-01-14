import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 221, 218, 58)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final List<String> options = [
    '石头', '剪刀', '布'
  ];
  var current = '';
  var old = '';
  int nextCount = 0;
  int oldCount = 0;

  MyAppState() {
    current = getRandomOption();
    old = getRandomOption();
  }

  String getRandomOption() {
    final random = Random();
    return options[random.nextInt(options.length)];
  }

  void getNext() {
    if ((nextCount - oldCount).abs() <= 1) {
      current = getRandomOption();
      nextCount++;
      notifyListeners();
    }
  }

  void getOld() {
    if ((nextCount - oldCount).abs() <= 1) {
      old = getRandomOption();
      oldCount++;
      notifyListeners();
    }
  }

  void refresh() {
    old = current;
    nextCount = 0; // 重置 nextCount
    oldCount = 0; // 重置 oldCount
    notifyListeners();
  }

  void addCustomOption(String input) {
    List<String> newOptions = input.split(' ').map((option) => option.trim()).toList();
    options.clear(); // 清空原始字段列表
    options.addAll(newOptions); // 添加用户输入的选项
    current = options.isNotEmpty ? options[0] : ''; // 更新 current 为新选项
    old = ''; // 清空 old
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var customOptionController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20), // 增加间隔
          Center(
            child: Text('分歧争端机'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: customOptionController,
                  decoration: InputDecoration(labelText: 'Custom Options (space separated)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    appState.addCustomOption(customOptionController.text);
                    customOptionController.clear(); // 清空输入框
                  },
                  child: Text('Add Custom Options'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(appState.current),
                      SizedBox(height: 20), // 增加间隔
                      ElevatedButton(
                        onPressed: (appState.nextCount - appState.oldCount).abs() <= 1
                            ? () {
                                appState.getNext();
                              }
                            : null,
                        child: Text('Next (${appState.nextCount})'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(appState.old),
                      SizedBox(height: 20), // 增加间隔
                      ElevatedButton(
                        onPressed: (appState.nextCount - appState.oldCount).abs() <= 1
                            ? () {
                                appState.getOld();
                              }
                            : null,
                        child: Text('Old (${appState.oldCount})'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // 增加间隔
          Center(
            child: ElevatedButton(
              onPressed: () {
                appState.refresh();
              },
              child: Text('Refresh'),
            ),
          ),
          SizedBox(height: 20), // 增加间隔
        ],
      ),
    );
  }
}