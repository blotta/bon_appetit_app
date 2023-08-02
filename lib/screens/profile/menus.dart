import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/menu_edit.dart';
import 'package:flutter/material.dart';

class MenusScreen extends StatelessWidget {
  const MenusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToMenuEdit(Menu? m) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => MenuEditScreen(menu: m)));
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: const Text('Cardápios'),
        actions: [
          IconButton(onPressed: () => navigateToMenuEdit(null), icon: const Icon(Icons.add))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView.builder(
          itemCount: dataMenus.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              onTap: () => navigateToMenuEdit(dataMenus[index]),
              title: Text(dataMenus[index].name),
              trailing: const Icon(Icons.arrow_right_alt, size: 40),
            );
          },
        ),
      ),
    );
  }
}
