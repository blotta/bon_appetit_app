import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/screens/profile/menu_edit.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';

class MenuNewScreen extends StatefulWidget {
  const MenuNewScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<MenuNewScreen> createState() => _MenuNewScreenState();
}

class _MenuNewScreenState extends State<MenuNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _enteredName = TextEditingController();
  final _enteredDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _enteredName.dispose();
    _enteredDescription.dispose();
    super.dispose();
  }

  void _createMenu() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var menu = DMenu('', _enteredName.text, []);

      var menuId = await BonAppetitApiService()
          .postCreateMenu(widget.restaurantId, menu);

      if (menuId != null) {
        var newMenu = await BonAppetitApiService()
            .getPartnerMenu(widget.restaurantId, menuId);
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => MenuEditScreen(menu: newMenu!)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: const Text('Novo Cardápio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _enteredName,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text('Nome')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nome inválido";
                            }
                            if (value.length < 3) {
                              return "Nome muito curto";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _enteredDescription,
                          maxLength: 150,
                          maxLines: 3,
                          decoration:
                              const InputDecoration(label: Text('Descrição')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Descrição inválida";
                            }
                            if (value.length < 3) {
                              return "Descrição muito curta";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                      ]),
                ),
              ),
            ),
            Visibility(
              // hide when keyboard visible
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createMenu,
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                  child: const Text('CRIAR'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
