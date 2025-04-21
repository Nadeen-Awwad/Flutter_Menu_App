import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'adminSection/authentication/screens/signIn_screen.dart';
import 'adminSection/authentication/screens/signUp_screen.dart';
import 'adminSection/blocs/authentication/auth_bloc.dart';
import 'adminSection/blocs/cartBloc/cart_bloc.dart';
import 'adminSection/blocs/category/category_bloc.dart';
import 'adminSection/blocs/category/category_event.dart';
import 'adminSection/blocs/dish/dish_bloc.dart';
import 'adminSection/blocs/dish/dish_event.dart';
import 'adminSection/dashboard/screens/dashboard_screen.dart';
import 'adminSection/utils/language_Provideer.dart';
import 'adminSection/utils/theme_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSize = 100; // Adjust as needed

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark, 
  ));

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc()..add(LoadCategories())),
        BlocProvider(create: (_) => DishBloc()..add(LoadDishes())),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Mat3ami',
      debugShowCheckedModeBanner: false,
      locale: languageProvider.locale,
      supportedLocales: [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: themeProvider.scaffoldBackgroundColor,
        colorScheme: ColorScheme.light(
          primary: themeProvider.primaryColor,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: themeProvider.scaffoldBackgroundColor,
          colorScheme: ColorScheme.dark(
            primary: themeProvider.primaryColor,
          )),
      themeMode: themeProvider.themeMode,
      home: Dashboard(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: "/login",
      routes: {
        "/login": (context) => SignInScreen(),
        "/signup": (context) => SignUpScreen(),
        "/home": (context) => Dashboard(),
      },
    );
  }
}
