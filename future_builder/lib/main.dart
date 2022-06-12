import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
   Homepage({Key? key}) : super(key: key);

  List<Map<String,dynamic>> allUser = [];

  Future getAllUse() async {
    try {
      var response = await http.get(Uri.parse("https://reqres.in/api/users"));
      List data= (json.decode(response.body) as Map<String,dynamic>)["data"];
      data.forEach((element) {
        allUser.add(element);
      });

    } catch (e) {
      print("terjadi error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder'),
      ),
      body: FutureBuilder(
          future: getAllUse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('loading......'),
              );
            } else {
              return ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(allUser[index]['avatar']),
                  ),
                  title: Text("${allUser[index]['first_name']} ${allUser[index]['last_name']}"),
                  subtitle: Text(allUser[index]['email']),
                ),
              );
            }
          }),
    );
  }
}
