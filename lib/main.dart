import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_transdata/services/firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_transdata/firebase_options.dart';

ColorScheme firstTheme = ColorScheme.fromSeed(seedColor: Colors.blue, surface: const Color(0xFF63A5BF), primary: const Color(0xFF63A5BF), secondary: const Color(0xFF0A6073));

ColorScheme secondTheme = ColorScheme.fromSeed(seedColor: Colors.blue, surface: const Color(0xFFDBE3EA), surfaceContainer: const Color(0xFFFFFFFF), primary: const Color(0xFF3374AA), secondary: const Color(0xFF75A1C8), onSecondary: const Color(0xFF000000), secondaryContainer: const Color(0xFF598FBB), tertiary: const Color(0xA8BDD8EE), onTertiary: const Color(0xFF000000));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  const permissionStorage = Permission.storage;

  var permissionGranted = true;

  if (Platform.isAndroid) {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      final permissionStorage = Permission.storage;
      final status = await permissionStorage.request();
      if (status.isGranted) {
        permissionGranted = true;
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isDenied) {
        // Permission denied
        permissionGranted = false;
        print('Location permission denied.');
      }
    }
  }

  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  var verify;
  var name;
  if(permissionGranted){
    if(await prefs.getBool('verify') == null){
      await prefs.setBool('verify', false);
    }
    if(await prefs.getBool('admin') == null){
      await prefs.setBool('admin', false);
    }
    if(await prefs.getString('page') == null){
      await prefs.setString('page', 'all_request');
    }
    verify = await prefs.getBool('verify');
    name = await prefs.getString('username');
    print('Storage permission authorized.');
  } else {
    // Permission denied
    print('Storage permission denied.');
    exit(0);
  }
  runApp(MyApp(name, verify!)
  );
}

class MyApp extends StatefulWidget {
  final String? name;
  final bool verify;
  const MyApp(this.name, this.verify, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _showErrorDialog(details.exceptionAsString());
    };
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //SharedPreferences.setMockInitialValues({});
    return MaterialApp(
      title: 'TDS',
      theme: ThemeData(
        colorScheme: secondTheme,
        useMaterial3: true,
      ),
      home: (widget.name==''||widget.name==null) && !widget.verify?const LoginPage():!(widget.name==''||widget.name==null) && !widget.verify?const VerifyCodePage():const MainPage(),
    );
  }
}

class ErrorHandlerWidget extends StatefulWidget {
  final Widget child;

  ErrorHandlerWidget({required this.child});

  @override
  _ErrorHandlerWidgetState createState() => _ErrorHandlerWidgetState();
}

class _ErrorHandlerWidgetState extends State<ErrorHandlerWidget> {
  // Error handling logic
  void onError(FlutterErrorDetails errorDetails) {
    // Add your error handling logic here, e.g., logging, reporting to a server, etc.
    print('Caught error: ${errorDetails.exception}');
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetBuilder(
      builder: (context, errorDetails) {
        // Display a user-friendly error screen
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(
            child: Text('Something went wrong. Please try again later.'),
          ),
        );
      },
      onError: onError,
      child: widget.child,
    );
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final Widget Function(BuildContext, FlutterErrorDetails) builder;
  final void Function(FlutterErrorDetails) onError;
  final Widget child;

  ErrorWidgetBuilder({
    required this.builder,
    required this.onError,
    required this.child,
  });

  @override
  _ErrorWidgetBuilderState createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    // Set up global error handling
    FlutterError.onError = widget.onError;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
