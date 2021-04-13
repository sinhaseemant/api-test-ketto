import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> apiResult;
  String _title;
  String _author;
  bool _isLoading = true;

  Future<void> onRefresh() async {
    fetchAndSetData();
  }

  Future<void> fetchAndSetData() async {
    var url = 'http://api.quotable.io/random';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.body == "null") {
        throw "error";
      }
      setState(() {
        _isLoading = false;
        apiResult = json.decode(response.body);
        _title = apiResult['content'];
        _author = apiResult['author'];
      });
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    fetchAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Test"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchAndSetData)
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            children: <Widget>[
              ListView(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Card(
                              color: Colors.grey[200],
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        _title == null ? "" : _title,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        _title == null ? "" : _author,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
