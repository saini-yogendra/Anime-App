import 'package:flutter/material.dart';
import 'package:anime_app/view/Screens/home/home_screen.dart';
import '../browse/browse_screen.dart';
import '../myList/my_list_screen.dart';
import '../setting/setting_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    MyListScreen(),
    BrowseScreen(),
    SettingsScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.bookmark_border,
    Icons.menu_book_outlined,
    Icons.person_outline,
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.white : Colors.grey,
        size: 28,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF09090F),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 8),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF09090F),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 10,
          items: List.generate(
            _icons.length,
                (index) => _buildBottomNavItem(_icons[index], index),
          ),
        ),
      ),
    );
  }
}
