import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AddData.dart';
import 'package:flutter_application_1/Screens/HomeScreen.dart';
import 'package:flutter_application_1/Screens/Profile.dart';

class BottomNaviScreen extends StatefulWidget {
  const BottomNaviScreen({super.key});

  @override
  State<BottomNaviScreen> createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  int selectedtab = 0;

  List Screens = [
    const HomeScreen(),
    AddData(),
    const Profile(),
  ];

  void _changetab(int index) {
    setState(() {
      selectedtab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[selectedtab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedtab,
        onTap: (index) => _changetab(index),
        selectedItemColor: Colors.indigo.shade900,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
