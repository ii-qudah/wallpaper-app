import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/helpers/sql_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List images = [];
  int page = 0;
  var path;

  @override
  void initState() {
    super.initState();
    getWallpaper();
    updateImageList();
  }

  updateImageList() {
    images.forEach((image) => image['isFavorite'] = false);
  }

  getWallpaper() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=39'),
        headers: {
          'Authorization':
              'ZVo10ly0AxG9YP0HxxRS9rInyqnE1MbcGJe92HT30wnVn72Tl5rQjSd1'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      updateImageList();
      print(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sqlDb = Provider.of<SQLHelper>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: images.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 4,
                              crossAxisCount: 3,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 4),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(25),
                                    topStart: Radius.circular(25),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Image.network(
                                                images[index]['src']['large'],
                                              ),
                                              Positioned(
                                                right: 5,
                                                top: 5,
                                                child: Container(
                                                    color: Colors.white,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                          size: 25,
                                                        ))),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 15),
                                            color: Colors.black,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter setState) {
                                                  return IconButton(
                                                    onPressed: () async {
                                                      bool exists = await sqlDb
                                                          .checkExists(
                                                              images[index]
                                                                      ['src']
                                                                  ['large']);
                                                      if (exists) {
                                                        int response = await sqlDb
                                                            .deleteData(
                                                                "DELETE FROM wallpaper WHERE url = '${images[index]['src']['large']}'");
                                                        print(
                                                            'Deleted $response record');
                                                      } else {
                                                        int response = await sqlDb
                                                            .insertData(
                                                                "INSERT INTO wallpaper('url', 'key' ,'photographer') VALUES('${images[index]['src']['large']}', 'ZVo10ly0AxG9YP0HxxRS9rInyqnE1MbcGJe92HT30wnVn72Tl5rQjSd1' ,'${images[index]['photographer']}')");
                                                        print(
                                                            'Inserted $response record');
                                                      }
                                                      setState(() {
                                                        updateImageList();
                                                        images[index]
                                                                ['isFavorite'] =
                                                            !images[index]
                                                                ['isFavorite'];
                                                      });
                                                    },
                                                    icon: images[index]
                                                            ['isFavorite']
                                                        ? Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                            size: 32,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_border,
                                                            size: 30,
                                                          ),
                                                  );
                                                }),
                                                IconButton(
                                                    onPressed: () {
                                                      path = images[index]
                                                          ['src']['large'];
                                                      print('downloaded');
                                                      GallerySaver.saveImage(
                                                        path.toString(),
                                                        toDcim: true,
                                                      );
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Downloaded to photos'),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.download,
                                                      size: 30,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            color: Colors.white,
                            child: Image.network(
                              images[index]['src']['tiny'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
