import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResult = [];

  TextEditingController searchController = TextEditingController();

  getPhotographer(String query) async {
    final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=39'),
        headers: {
          'Authorization':
              'ZVo10ly0AxG9YP0HxxRS9rInyqnE1MbcGJe92HT30wnVn72Tl5rQjSd1'
        });

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> result = jsonDecode(response.body);
        searchResult = result['photos'];
      });
    } else {
      throw Exception('Failed to load search result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: getPhotographer,
          decoration: const InputDecoration(
            hintText: 'Search wallpaper',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: searchResult.isEmpty
                  ? Center(
                      child: Text(
                        'Search wallpapers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: searchResult.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 4,
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 4),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  searchResult[index]['src']['tiny'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                searchResult[index]['photographer'],
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
