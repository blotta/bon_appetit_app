import 'package:bon_appetit_app/screens/menu.dart';
import 'package:bon_appetit_app/screens/profile.dart';
import 'package:bon_appetit_app/screens/qr_scanner.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:bon_appetit_app/screens/initial.dart';
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

  void navigateToRestaurantMenu(String restaurantId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MenuScreen(restaurantId: restaurantId)));
  }

  void onQRCodeScanningDone(String code) {
    setState(() {
      _selectedPageIndex = 0;
    });
    var url = Uri.tryParse(code);
    if (url != null && url.pathSegments.isNotEmpty) {
      navigateToRestaurantMenu(url.pathSegments.first);
      return;
    }

    showErrorSnackbar(context, "QR code inválido");
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const InitialScreen();

    if (_selectedPageIndex == 1) {
      activePage = QRScannerScreen(onScanningDone: onQRCodeScanningDone);
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
