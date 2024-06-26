import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../views.dart';
import '../../utils/utilities.dart';
import '../../providers/theme_provider.dart';

class MainNavigationPage extends StatefulWidget {
  final int initialIndex;

  const MainNavigationPage({
    super.key,
    this.initialIndex=0
  });

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigationPage> {
  late ThemeProvider themeProvider;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const KeyManagementPage(),
    const CharactersListPage(),
    const ChatRoomsListPage(),
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
    themeProvider = context.read<ThemeProvider>();
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack( //this will call onBackPress() from FriendsPage() in every page
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
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