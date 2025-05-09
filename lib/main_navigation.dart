import 'package:flutter/material.dart';
import 'package:fit_rpg/activity_page.dart';
import 'package:fit_rpg/game_page_static.dart';
import 'package:fit_rpg/game_page_active.dart';
import 'package:fit_rpg/profile_page.dart';

class MainNavigation extends StatefulWidget 
{
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> 
{
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const ProfilePage(),
    const ActivityPage(),
    const GamePageStatic(),
    const GamePageActive(),
  ];

  void _onItemTapped(int index) 
  {
    setState(() 
    {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), //placeholder icon
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run), //placeholder icon
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), //placeholder icon
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset), //placeholder icon
            label: 'Game',
          ),
        ],
      ),
    );
  }
}
