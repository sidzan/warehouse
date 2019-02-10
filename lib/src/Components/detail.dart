import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class DetailStateFul extends StatefulWidget {
  DetailStateFul({Key key, this.item}) : super(key: key);

  final item;

  @override
  State<StatefulWidget> createState() {
    return new DetailState();
  }
}

class DetailState extends State<DetailStateFul> {
  var data;
  var _loading = true;

  _getData() async {
    var _productCode = widget.item['productCode'];
    final String url =
        "https://devapi.bchurunway.com/v1/en/products/" + _productCode;
    final response = await http.get(url, headers: {
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNTZqdjZ3a25URnZ1SDUyUEEiLCJpYXQiOjE1NDc2Mzg3NjYsImV4cCI6MTU0NzcyNTE2Nn0.TOk1ayJpFudlOwnOh7KtZ2idrSwHDR74GYKwIwfe4bo"
    });
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      if (map["error"] == true) {
        print("Something went Wrong");
        return;
      }
      this.data = data;
    }
  }

  void initState() {
    _getData();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return Scaffold(
        body: new Container(
            padding: EdgeInsets.all(10.0),
            // This should be a new Image
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: new Container(
                      child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Image.network(item['productImage']),
                      new Text(
                        item["productCode"],
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      new Text(
                        item["brand"],
                        style: TextStyle(
                            fontSize: 9.0, fontStyle: FontStyle.italic),
                      ),
                      new Text(
                        item["productName"],
                        style: TextStyle(fontSize: 12.0),
                      )
                    ],
                  )),
                ),
                Expanded(
                  flex: 5,
                  child: new Container(
                    padding: new EdgeInsets.all(5.0),
                    child: new Column(
                      children: <Widget>[
                        _loading
                            ? new MaterialButton(
                                onPressed: () {
                                  print("Test");
                                },
                                child: Text("Testing"),
                                color: Colors.blue,
                              )
                            : "loaded"
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
