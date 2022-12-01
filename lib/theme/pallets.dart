
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/enums/enums.dart';



// ignore: prefer_function_declarations_over_variables
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier,ThemeData>((ref) {
  return ThemeNotifier();
});


class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    backgroundColor: drawerColor,
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    backgroundColor: whiteColor,
  );
}
class ThemeNotifier extends StateNotifier<ThemeData>{

  ThemeModes _mode;
  ThemeNotifier(
    {ThemeModes mode=ThemeModes.dark})
    :_mode=mode,
    super(Pallete.darkModeAppTheme){
      getTheme();
    }


  ThemeModes get mods=>_mode;
  void getTheme()async{

  SharedPreferences prefs=await SharedPreferences.getInstance();
  final theme=prefs.getString('theme');
  if(theme=='light'){
    _mode=ThemeModes.light;
    state=Pallete.lightModeAppTheme;
  }else{
     _mode=ThemeModes.dark;
     state=Pallete.darkModeAppTheme;
  }
 
  }

  void toggleTheme()async{
     SharedPreferences prefs=await SharedPreferences.getInstance();
     if(_mode==ThemeModes.dark){
        _mode=ThemeModes.light;
        state=Pallete.lightModeAppTheme;
        prefs.setString('theme', 'light');
      }else{
         _mode=ThemeModes.dark;
         state=Pallete.darkModeAppTheme;
         prefs.setString('theme', 'dark');
          }
  }
}