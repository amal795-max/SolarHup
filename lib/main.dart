import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:untitled1/core/translation/app_localization.dart';

import 'core/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      title: 'Flutter Demo',
      supportedLocales: const <Locale>[
       Locale('en'),
        Locale('ar')],
      localizationsDelegates: const [AppLocalizations.delegate],
      localeResolutionCallback: (deviceLocal, supportedLocales) {
        for (var local in supportedLocales) {
          if (deviceLocal != null &&
              deviceLocal.languageCode == local.languageCode) {
            return deviceLocal;
          }
        }
        return supportedLocales.first;
      },
      routerConfig: router,    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(AppLocalizations.of(context)!.translate('hello')),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
