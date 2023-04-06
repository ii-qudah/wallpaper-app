import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperapp/helpers/sql_helper.dart';
import 'package:wallpaperapp/screens/home_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  favoritescreenState createState() => favoritescreenState();
}

class favoritescreenState extends State<FavoriteScreen> {
  SQLHelper sqlDb = SQLHelper();
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    sqlDb =
        Provider.of<SQLHelper>(context, listen: false); // to not rebuild when
    getFavorites();
  }

  getFavorites() async {
    var db = await sqlDb.db;
    var result =
        await sqlDb.readData('SELECT * FROM wallpaper ORDER BY id DESC');
    print(result);
    setState(() {
      favorites = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: favorites.isEmpty
                  ? Center(
                      child: Text(
                        'No favorite wallpapers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: favorites.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 4,
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 4),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  favorites[index]['url'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                favorites[index]['photographer'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
