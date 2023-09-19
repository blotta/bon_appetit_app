import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/section_edit.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:bon_appetit_app/utils/input.dart';
import 'package:flutter/material.dart';

class MenuEditScreen extends StatefulWidget {
  const MenuEditScreen({super.key, required this.menu});

  final DMenu menu;

  @override
  State<MenuEditScreen> createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  List<DMenuSection> _menuSections = [];

  final GlobalKey<FormState> _newSectionFormKey = GlobalKey<FormState>();

  final _newSectionNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _enteredName = widget.menu.name;
      _menuSections = widget.menu.sections;
    });
  }

  void _saveMenu() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.of(context).pop();
    }
  }

  Future _createSection(String secName) async {
    var newSec = DMenuSection('', secName, []);
    var newSecId = await BonAppetitApiService()
        .postCreateMenuSection(widget.menu.id, newSec);
    if (newSecId != null) {
      setState(() {
        _menuSections.add(DMenuSection(newSecId, secName, []));
      });
    }
  }

  Future<bool> _deleteSection(String menuSectionId) async {
    var secId = await BonAppetitApiService()
        .deleteMenuSection(widget.menu.id, menuSectionId);
    if (secId != null) {
      setState(() {
        // _menuSections.remove(section);
      });
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _newSectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void navigateToSectionEdit(DMenuSection section) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => SectionEditScreen(menuId: widget.menu.id, section: section)));
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: const Text('Editar Cardápio'),
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
                          readOnly: true,
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
                            return Dismissible(
                              key: Key(_menuSections[index].name),
                              background: Container(
                                alignment: Alignment.centerLeft,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.white, Colors.red])),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.blue, Colors.white])),
                                child: const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blue,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  bool excludeSection = await confirmDialog(
                                      context, "Deseja mesmo excluir a seção?",
                                      yesText: "Sim, excluir");
                                  if (excludeSection) {
                                    // _deleteSection(_menuSections[index]);
                                    loadingDialog(
                                        context, "Excluindo seção...");
                                    var success = await _deleteSection(
                                        _menuSections[index].id);
                                    Navigator.of(context).pop();
                                    if (!success) {
                                      showErrorSnackbar(context,
                                          "Erro ao tentar excluir seção");
                                    }
                                    return success;
                                  }
                                  return excludeSection;
                                }
                              },
                              child: ListTile(
                                onTap: () {
                                  navigateToSectionEdit(_menuSections[index]);
                                },
                                title: Text(_menuSections[index].name),
                                trailing: const Icon(Icons.arrow_right_alt),
                                leading: ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(
                                    Icons.drag_handle,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
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
                            onPressed: () async {
                              var secName = await getStringDialog(
                                  context,
                                  _newSectionNameController,
                                  _newSectionFormKey,
                                  "Nova Seção",
                                  "Nome da seção");
                              print(secName);
                              if (secName != null) {
                                loadingDialog(context, null);
                                await _createSection(secName);
                                Navigator.of(context).pop();
                              }
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
                  child: const Text('SALVAR'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
