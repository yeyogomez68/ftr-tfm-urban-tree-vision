import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ftrlibcuestionario/globals/globals.dart';
import 'package:ftrurbantreevision/pages/home/home.dart' as home;
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this import statement

void main() {
  // Inicializar variables globales
  Globals.urlAPI =
      "https://academicoapi.cleverapps.io"; //"http://192.168.1.4:5113"; "https://academicoapi.cleverapps.io";
  Globals.pathAPI = "/api";
  Globals.apiKeyPlatform = "1973";
  Globals.apiKeyClient = "1980";
  Globals.serialDevice = "DEV22662";
  Globals.lottieFile = "assets/flores.json";
  Globals.titleApp = "Urban Tree Vision";
  Globals.empresaNombre = "TFE";
  Globals.idEmpresa = 7;
  Globals.permitirCrearUsuario = true;
  Globals.permitirPrediccionFoto = true;
  Globals.modelPaths = [
    "assets/models/VGG16.tflite",
    "assets/models/DenseNet121.tflite",
    "assets/models/InceptionV3.tflite",
    "assets/models/MobileNetV2.tflite",
  ];
  Globals.modelClasses = [
    "Buganbil, veranera",
    "Caballero de la noche, Jazmin, Dama de noche",
    "Chicala, chirlobirlo, flor amarillo",
    "Chicala rosado",
    "Eugenia",
    "Guayacan de Manizales",
    "Pino colombiano, pino de pacho, pino romerón"
  ];

  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    home: ProviderScope(child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final darkModeStartTime = TimeOfDay(hour: 20, minute: 0);
    final darkModeEndTime = TimeOfDay(hour: 6, minute: 0);
    final isDarkMode = currentTime.hour >= darkModeStartTime.hour ||
        currentTime.hour <= darkModeEndTime.hour;
    Globals.context = context;
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: const Color.fromRGBO(25, 118, 210, 1), //login
        title: Globals.titleApp,
        darkTheme: ThemeData.dark(),
        themeMode:
            ThemeMode.light, //isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: const Color.fromRGBO(247, 147, 30, 1),
          splashColor: const Color.fromRGBO(64, 191, 239, 1),
          scaffoldBackgroundColor: Colors.transparent,
          secondaryHeaderColor: Colors.red,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                fontSize: 18.0, color: Colors.black, letterSpacing: 0),
            bodyMedium: TextStyle(
                fontSize: 16.0, color: Colors.black, letterSpacing: 0),
            bodySmall: TextStyle(
                fontSize: 14.0, color: Colors.black, letterSpacing: 0),
            displayLarge: TextStyle(
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            displayMedium: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            displaySmall: TextStyle(fontSize: 16.0, color: Colors.white),
            titleLarge: TextStyle(
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            titleMedium: TextStyle(fontSize: 22.0, color: Colors.black),
            titleSmall: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          inputDecorationTheme: InputDecorationTheme(
            suffixIconColor: Colors.orange,
            counterStyle: const TextStyle(
                height: double.minPositive, color: Colors.orange),
            contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
            labelStyle: const TextStyle(
                backgroundColor: Colors.white,
                color: Colors.orange,
                fontSize: 18.0),
            fillColor: Colors.white,
            filled: true,
            floatingLabelStyle: const TextStyle(
                color: Colors.orange,
                letterSpacing: 0,
                fontSize: 18,
                overflow: TextOverflow.ellipsis),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Colors.orange, width: 1, style: BorderStyle.solid),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Colors.red, width: 1, style: BorderStyle.solid),
            ),
            errorStyle: const TextStyle(color: Colors.orange),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintStyle:
                TextStyle(fontSize: 17, color: Colors.grey.withOpacity(.3)),
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('es', ''), // Spanish, no country code
          // ... other locales the app supports
        ],
        home: home.Home(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
