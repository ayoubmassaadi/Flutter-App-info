import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String keyword = ""; // Initialize keyword

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(keyword.isNotEmpty ? keyword : 'Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Key word'),
              onChanged: (value) {
                setState(() {
                  keyword = value;
                });
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GalleryData(keyword: value),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a keyword')),
                  );
                }
              },
            ),
            SizedBox(height: 16.0), // Add space between TextField and Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (keyword.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GalleryData(keyword: keyword),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a keyword')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                ),
                child: Text('Get Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryData extends StatefulWidget {
  final String keyword;

  GalleryData({required this.keyword});

  @override
  _GalleryDataState createState() => _GalleryDataState();
}

class _GalleryDataState extends State<GalleryData> {
  List<dynamic> hits = [];
  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 0;
  late ScrollController _scrollController;
  Map<String, dynamic> dataGallery = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (currentPage < totalPages) {
        ++currentPage;
        loadData();
      }
    }
  }

  Future<void> loadData() async {
    String url =
        "https://pixabay.com/api/?key=45226287-a26865e26f61d2b4239384c7f&q=${widget.keyword}&page=$currentPage&per_page=$pageSize";
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          dataGallery = json.decode(response.body);
          hits.addAll(dataGallery['hits']);
          totalPages = (dataGallery['totalHits'] / pageSize).ceil();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.keyword} : $currentPage / $totalPages'),
        backgroundColor: Colors.deepOrange,
      ),
      body: hits.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: hits.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        color: Colors.deepOrange,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            hits[index]['tags'],
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        child: Image.network(
                          hits[index]['previewURL'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey, thickness: 2),
                  ],
                );
              },
            ),
    );
  }
}
