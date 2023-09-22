import 'dart:async';

import 'package:bon_appetit_app/screens/menu.dart';
import 'package:bon_appetit_app/screens/profile.dart';
import 'package:bon_appetit_app/screens/qr_scanner.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:bon_appetit_app/screens/initial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key, this.restaurantId});

  final String? restaurantId;

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

  void navigateToRestaurantMenu(String restaurantId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MenuScreen(restaurantId: restaurantId)));
  }

  void handleLink(String link) {
    setState(() {
      _selectedPageIndex = 0;
    });
    var url = Uri.tryParse(link);

    // restaurantId or /restaurantId
    if (url != null && url.pathSegments.isNotEmpty) {
      navigateToRestaurantMenu(url.pathSegments.first);
      return;
    }

    // /#/restaurantId (full link)
    if (url != null && url.hasFragment) {
      navigateToRestaurantMenu(url.fragment.replaceFirst('/', ''));
      return;
    }

    showErrorSnackbar(context, "Link inválido");
  }

  @override
  void initState() {
    if (widget.restaurantId != null) {
      Timer(const Duration(milliseconds: 100), () => handleLink(widget.restaurantId!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  print(widget.restaurantId);
    Widget activePage = const InitialScreen();

    if (_selectedPageIndex == 1) {
      activePage = QRScannerScreen(onScanningDone: handleLink);
    }

    if (_selectedPageIndex == 2) {
      activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Theme.of(context).colorScheme.surface,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.qr_code),
              label: '',
              backgroundColor: Theme.of(context).colorScheme.primary),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
