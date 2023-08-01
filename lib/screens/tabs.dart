import 'package:flutter/material.dart';
import 'package:bon_appetit_app/screens/initial.dart';
import 'package:bon_appetit_app/screens/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage = const InitialScreen();

    if (_selectedPageIndex == 1) {
      activePage = const MenuScreen();
    }

    return Scaffold(
      // appBar: AppBar(title: const Text('Bon Appetit')),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.qr_code),
              label: '',
              backgroundColor: Theme.of(context).colorScheme.primary),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
