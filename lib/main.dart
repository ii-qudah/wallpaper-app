import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperapp/screens/home_screen.dart';
import 'package:wallpaperapp/helpers/wallpaper_layout.dart';

import 'helpers/sql_helper.dart';

// Future<void> main() async {
//   runApp(const wallpaperapp());
// }
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SQLHelper(),
      child: wallpaperapp(),
    ),
  );
}

class wallpaperapp extends StatelessWidget {
  const wallpaperapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      title: "Wallpaper App",
      home: LayoutScreen(),
    );
  }
}
