import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_details.dart';
import 'package:bon_appetit_app/screens/profile/section_edit.dart';
import 'package:flutter/material.dart';

class MenuEditScreen extends StatefulWidget {
  const MenuEditScreen({super.key, this.menu});

  final Menu? menu;

  @override
  State<MenuEditScreen> createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  List<MenuSection> _menuSections = [];

  @override
  void initState() {
    super.initState();

    if (widget.menu != null) {
      setState(() {
        _enteredName = widget.menu!.name;
        _menuSections = widget.menu!.sections;
      });
    }
  }

  void _saveMenu() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.menu != null) {
        // edit
        Navigator.of(context).pop();
      } else {
        // new
        var r = dataRestaurants[0];
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => RestaurantDetailsScreen(restaurant: r)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    void navigateToSectionEdit(MenuSection section) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => SectionEditScreen(section: section)));

    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: Text(widget.menu == null ? 'Novo Cardápio' : 'Editar Cardápio'),
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
                          initialValue: _enteredName,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text('Nome')),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Seções',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          primary: false, // play nice with scrolling
                          buildDefaultDragHandles: false,
                          itemCount: _menuSections.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              key: Key(_menuSections[index].name),
                              onTap: () => navigateToSectionEdit(_menuSections[index]),
                              title: Text(_menuSections[index].name),
                              trailing: const Icon(Icons.arrow_right_alt),
                              leading: ReorderableDragStartListener(
                                index: index,
                                child: Icon(
                                  Icons.drag_handle,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            );
                          },
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item = _menuSections.removeAt(oldIndex);
                              _menuSections.insert(newIndex, item);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              String baseName = "Nova seção";
                              String name = baseName;
                              int counter = 1;
                              while (_menuSections
                                  .any((sec) => sec.name == name)) {
                                name = '$baseName $counter';
                                counter++;
                              }
                              setState(() {
                                _menuSections.add(MenuSection(name, []));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(2))),
                            child: const Text("Adicionar Seção"),
                          ),
                        ),
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
                  onPressed: _saveMenu,
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                  child: Text(widget.menu == null ? 'CRIAR' : 'SALVAR'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
