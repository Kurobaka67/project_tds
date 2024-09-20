import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_transdata/services/request_local_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString('username');
  await RequestLocalService().getAllRequests();

  runApp(MyApp(name));
}

class MyApp extends StatefulWidget {
  final String? name;
  const MyApp(this.name, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SharedPreferences.setMockInitialValues({});
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, primary: const Color(0xFF63A5BF), secondary: const Color(0xFF0A6073)),
        useMaterial3: true,
      ),
      home: widget.name==''||widget.name==null?const LoginPage():const MainPage(),
    );
  }
}
