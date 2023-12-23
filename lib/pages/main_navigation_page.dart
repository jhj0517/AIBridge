import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/pages.dart';
import '../utils/utilities.dart';
import '../constants/constants.dart';

class MainNavigationPage extends StatefulWidget {
  final int initialIndex;

  const MainNavigationPage({Key? key, this.initialIndex=0}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const KeyManagementPage(),
    const CharactersPage(),
    const ChatRoomsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      Utilities.closeKeyboard(context);
    });
  }

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( //this will call onBackPress() from FriendsPage() in every page
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: ColorConstants.selectedNavigationItemColor,
        unselectedItemColor: ColorConstants.unSelectedNavigationItemColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.key),
            label: Intl.message("keyPageTitle"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: Intl.message("charactersPageTitle"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble),
            label: Intl.message("chatRoomsPageTitle"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: Intl.message("settingsPageTitle"),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}