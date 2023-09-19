import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _steps = 0;

  Future<void> getSteps() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    var now = DateTime.now();
    final stepPermission = await requestPermission();
    // 今日の歩数を取得する
    if (stepPermission) {
      var midnight = DateTime(now.year, now.month, now.day);
      int? steps = await health.getTotalStepsInInterval(midnight, now);
      setState(() {
        _steps = steps ?? 0;
      });
    }
  }

  Future<void> addSteps() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
    var now = DateTime.now();
    bool success =
        await health.writeHealthData(10, HealthDataType.STEPS, now, now);
    if (success) {
      await getSteps();
    }
  }

  Future<bool> requestPermission() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
    // 取得する型を定義する
    var types = [
      HealthDataType.STEPS, // 歩数
    ];
    // パーミッションのリクエスト
    var permissions = [
      HealthDataAccess.READ_WRITE,
    ];
    return await health.requestAuthorization(types, permissions: permissions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_steps',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                await getSteps();
              },
              child: const Text('Get Steps'),
            ),
            ElevatedButton(
              onPressed: () async {
                await addSteps();
              },
              child: const Text('Add Steps'),
            ),
          ],
        ),
      ),
    );
  }
}
