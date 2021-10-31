import 'package:flip/asset/custonicons.dart';
import 'package:flip/screens/flip.dart';
import 'package:flip/screens/roll.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  List<Widget> screens = [Roll(), Flip()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(CustomIcon.dice_1), label: 'dice'),
            BottomNavigationBarItem(
                icon: Icon(CustomIcon.coin_head), label: 'coin'),
          ],
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          }),
      body: screens[_index],
    );
  }
}
