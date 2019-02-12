import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
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
  TextEditingController searchController = new TextEditingController();
  String filter;
  var filteredData;
  Timer _debounce;
  NfcData _nfcData;

  var _loading = true;
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

  _onSearchChanged() {
    print("_onSearchCalled");
    setState(() {
      _loading = true;
    });
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      // do something with _searchQuery.text
      print(searchController.text);
      List<Object> filtered = [];
      filter = searchController.text;
      if (filter != null || filter != "") {
        this.data.forEach((d) {
          print(d);
          if (d["searchString"].toLowerCase().contains(filter.toLowerCase())) {
            filtered.add(d);
          }
        });
      }
      setState(() {
        filter = filter;
        filteredData = filtered;
      });
    });
  }

  void initState() {
    searchController.addListener(_onSearchChanged);
    _fetchData();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.nfc),
              onPressed: () {
                //_select(choices[0]);
                startNFC();
              },
            ),
          ],
        ),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                  itemCount: this.data != null ? this.data.length : 0,
                  itemBuilder: (context, i) {
                    var item;
                    if (filter == null || filter == "") {
                      item = this.data[i];
                    } else {
                      item = this.filteredData[i];
                    }
                    return new ItemStateFul(item: item);
//                    return new ItemStateFul(item: item);
                  }),
            ),
            new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> startNFC() async {
    NfcData response;

    setState(() {
      _nfcData = NfcData();
      _nfcData.status = NFCStatus.reading;
    });

    print('NFC: Scan started');

    try {
      print('NFC: Scan readed NFC tag');
      response = await FlutterNfcReader.read;
    } on PlatformException {
      print('NFC: Scan stopped exception');
    }
    setState(() {
      _nfcData = response;
      final snackBar = SnackBar(content: Text(response.content.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> stopNFC() async {
    NfcData response;

    try {
      print('NFC: Stop scan by user');
      response = await FlutterNfcReader.stop;
    } on PlatformException {
      print('NFC: Stop scan exception');
      response = NfcData(
        id: '',
        content: '',
        error: 'NFC scan stop exception',
        statusMapper: '',
      );
      response.status = NFCStatus.error;
    }

    setState(() {
      _nfcData = response;
    });
  }
}
/*
Working Code
                    return filter == null || filter == ""
                        ? new ItemStateFul(item: item)
                        : item["searchString"]
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? new ItemStateFul(item: item)
                            : new Container();
 */
