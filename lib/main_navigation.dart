import 'package:fit_rpg/audio_service.dart';
import 'package:fit_rpg/hub_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_rpg/activity_page.dart';
import 'package:fit_rpg/game_page_static.dart';
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
    const HubPage(),
  ];

  void _onItemTapped(int index) 
  {
    AudioService().playSFX('touch.wave');
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), //placeholder icon
            label: 'Profile',
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
            label: 'Base',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
