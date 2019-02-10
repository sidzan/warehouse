import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Import Custom Functions below
import './Items.dart';

class Items extends StatefulWidget {
  Items({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ItemState();
  }
}

class ItemState extends State<Items> {
  var _loading = false;
  var data;

  _fetchData() async {
    // Get Data from server
    final String url = "https://devapi.bchurunway.com/v1/en/list_products";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response);
      print(response.body);
      final map = json.decode(response.body);
      final data = map["data"];
      this.data = data;
      final snackBar = SnackBar(content: Text('Data Loaded!'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  void initState() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: new Scaffold(
        body: Center(
          child: _loading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: this.data != null ? this.data.length : 0,
                  itemBuilder: (context, i) {
                    final item = this.data[i];
                    return new ItemStateFul(item: item);
                  }),
        ),
        floatingActionButton: new FloatingActionButton(
          // TODO: this should be coming from the parent
          onPressed: () {
            setState(() {
              _loading = true;
            });
            _fetchData();
          },
          child: new Icon(Icons.refresh),
        ),
      ),
    );
  }
}
