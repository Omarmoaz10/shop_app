import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Screens/login/login_screen.dart';
import 'package:shop_app/Screens/products/products_screen.dart';
import 'package:shop_app/Screens/register/register_screen.dart';
import 'package:shop_app/Screens/settings/settings_screen.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'Screens/on_boarding/on_boarding_screen.dart';
import 'layout/cubit/cubit.dart';
import 'shared/network/remote/dio_helper.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
  bool onBoarding = CacheHelper.getData(key: "onBoarding");
  String token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding != null) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp({
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: OnBoardingScreen(),
          );
        },
      ),
    );
  }
}
