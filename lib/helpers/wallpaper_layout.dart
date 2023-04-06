import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:wallpaperapp/screens/delete_screen.dart';
import 'package:wallpaperapp/screens/favorite_screen.dart';
import 'package:wallpaperapp/screens/search_screen.dart';
import '../screens/home_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

int currentpage = 0;
String appbarTitle = "Home Screen";

List screens = [
  HomeScreen(),
  SearchScreen(),
  FavoriteScreen(),
  DeleteScreen(),
];

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home_outlined, color: Colors.black),
            title: Text('Home'),
            onTap: () {
              currentpage = 0;
              appbarTitle = "Home Screen";
              setState(() {});
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.search, color: Colors.black),
            title: Text('Search'),
            onTap: () {
              currentpage = 1;
              appbarTitle = "Search";

              setState(() {});
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border_outlined, color: Colors.black),
            title: Text('Favorite'),
            onTap: () {
              currentpage = 2;
              appbarTitle = "Favorites";
              setState(() {});
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.black),
            title: Text('Delete'),
            onTap: () {
              currentpage = 3;
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
      )),
      body: screens[currentpage],
    );
  }
}
