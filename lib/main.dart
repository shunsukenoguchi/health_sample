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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<void> getSteps() async {
    print('test1');
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
    print('test2');

    // define the types to get
    var types = [
      HealthDataType.STEPS,
    ];
    print('test3');

    // requesting access to the data types before reading them

    // bool requested = await health.requestAuthorization(types);
    print('test4');

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    // List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
    //     now.subtract(Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    types = [HealthDataType.STEPS];
    var permissions = [
      HealthDataAccess.READ_WRITE,
    ];

    await health.requestAuthorization(types, permissions: permissions);

    // // write steps and blood glucose
    // bool success =
    //     await health.writeHealthData(10, HealthDataType.STEPS, now, now);
    // success = await health.writeHealthData(
    //     3.1, HealthDataType.BLOOD_GLUCOSE, now, now);

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);

    print('steps : $steps');
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
                onPressed: () async {
                  await getSteps();
                },
                child: const Text('Get Steps')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
