import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
      theme: ThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          primarySwatch: Colors.amber,
          textTheme: TextTheme(title: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String token = '3fb82898c94773cf8fe76f29307ee1e61740243a';
  String url = 'https://owlbot.info/api/v4/dictionary/';
  TextEditingController tex = TextEditingController();
  StreamController k = StreamController();
  Stream j;

  search(TextEditingController tex) async {
    print('happen');

    if (tex.text == null || tex.text.length == 0) {
      k.add(null);

      print('This is a ${tex.text} Text');
    } else {
      http.Response respo = await http
          .get((url + tex.text), headers: {'Authorization': 'Token $token'});
      k.add(json.decode(respo.body));
    }
  }

  initState() {
    super.initState();
    j = k.stream;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practise Page'),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                      // margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: TextField(
                        controller: tex,
                        decoration: InputDecoration(hintText: 'Enter Word'),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        search(tex);
                      })
                ],
              ),
            )),
      ),
      body: StreamBuilder(
          initialData: null,
          stream: j,
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Center(child: Text('Type Something to Search'));
            else {
              return Container(
                child: Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount: (snapshot.data['definitions'] as List<dynamic>)
                          .length,
                      itemBuilder: (ctx, d) {
                        print((snapshot.data['definitions'] as List<dynamic>)
                            .length);
                        return Container(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Image.network(snapshot.data['definitions']
                                      [d]['image_url']
                                  .toString()),
                            ),
                            title: Text(snapshot.data['definitions'][d]
                                    ['definition']
                                .toString()),
                            subtitle: Text(snapshot.data['definitions'][d]
                                    ['example']
                                .toString()),
                            trailing: Text(snapshot.data['definitions'][d]
                                    ['type']
                                .toString()),
                          ),
                        );
                      }),
                ),
              );
            }
          }),
    );
  }
}
