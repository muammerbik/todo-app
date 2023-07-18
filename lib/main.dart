import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_do_app/data/local_storage.dart';
import 'package:flutter_to_do_app/model/task_model.dart';
import 'package:flutter_to_do_app/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStroge());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskbox = await Hive.openBox<Task>('tasks');
  for (var element in taskbox.values) {
    if (element.createAt.day != DateTime.now().day) {
      taskbox.delete(element.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await setupHive();
  setup();

  runApp( EasyLocalization(
      supportedLocales:const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', 
      fallbackLocale: Locale('en', 'US'),
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter To-Do App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              iconTheme: IconThemeData(color: Colors.black))),
      home: const HomePage(),
    );
  }
}
