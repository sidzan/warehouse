import 'package:flutter/material.dart';
import './detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemStateFul extends StatefulWidget {
  ItemStateFul({Key key, this.item}) : super(key: key);

  final item;

  @override
  State<StatefulWidget> createState() {
    return new ItemState();
  }
}

class ItemState extends State<ItemStateFul> {
  void _showModalSheet() {
    var item = widget.item;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new DetailStateFul(item: item);
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var item = widget.item;
    return new Column(
      children: <Widget>[
        new MaterialButton(
            onPressed: _showModalSheet,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: new Container(
                    child: new CachedNetworkImage(
                      placeholder: new Icon(Icons.cloud_circle),
                      imageUrl: item['productImage'],
                      height: 70.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: new Container(
                    padding: new EdgeInsets.all(5.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          item["brand"],
                          style: TextStyle(fontSize: 12.0),
                        ),
                        new Text(
                          item["productName"],
                          style: TextStyle(fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: new Container(
                    child: new Text(
                      item["productCode"],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ),
                )
              ],
            )),
        new Divider(),
      ],
    );
  }
}
