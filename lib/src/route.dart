import 'package:flutter/material.dart';
import './Components/BottomNavigation.dart';
import './Components/Home.dart';

final _widgetOptions = [
  Items(),
  Text('Index 1: Stands'),
  Text('Index 2: Settings'),
];

class Navigation extends StatefulWidget {
  Navigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0; //This is the Selected Index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Items(),
      // TODO: this should be dynamic ?
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
//        onPressed: _onItemTapped(_selectedIndex),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
