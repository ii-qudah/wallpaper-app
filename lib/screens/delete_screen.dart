import 'package:flutter/material.dart';
import 'package:wallpaperapp/helpers/sql_helper.dart';
import 'package:wallpaperapp/screens/search_screen.dart';

class DeleteScreen extends StatelessWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SQLHelper sqlDb = SQLHelper();
    return MaterialButton(
      onPressed: () async {
        await sqlDb.mydeleteDatabase();
      },
      child: Text(
        "delete DB",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
