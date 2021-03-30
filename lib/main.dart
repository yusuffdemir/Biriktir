
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'LoginCheck.dart';
import 'Models/CevrePuani.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CevrePuani()),
        ],
        child: new MediaQuery(
          data: new MediaQueryData(),
          child: new MaterialApp(
              localizationsDelegates: [
                // ... app-specific localization delegate[s] here
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),Locale('tr', '') // English and Turkish
                // ... other locales the app supports
              ],
              debugShowCheckedModeBanner: false,
              home: LoginCheck()),
        ),
      )
  );
}