import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/item_edit.dart';
import 'package:bon_appetit_app/screens/profile/items.dart';
import 'package:flutter/material.dart';

class SectionEditScreen extends StatefulWidget {
  const SectionEditScreen({super.key, required this.section});

  final MenuSection section;

  @override
  State<SectionEditScreen> createState() => _SectionEditScreenState();
}

class _SectionEditScreenState extends State<SectionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  List<MenuItem> _sectionItems = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _enteredName = widget.section.name;
      _sectionItems = widget.section.items;
    });
  }

  void _saveSection() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.of(context).pop();
    }
  }

  void navigateToItemsScreenAndGetItem() async {
    var newItem = await Navigator.of(context).push<MenuItem>(MaterialPageRoute(
        builder: (ctx) => const ItemsScreen(returnItemBehaviour: true)));

    if (newItem != null && !_sectionItems.any((i) => i.name == newItem.name)) {
      setState(() {
        _sectionItems.add(newItem);
      });
    }
  }

  navigateToItemEditScreen(MenuItem? item) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => ItemEditScreen(item: item)));
  }

  void removeItem(MenuItem item) {
    _sectionItems.remove(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: const Text('Seção'),
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
                        decoration: const InputDecoration(label: Text('Nome')),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Itens',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: navigateToItemsScreenAndGetItem,
                            icon: const Icon(Icons.add_box, size: 30),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ],
                      ),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        primary: false, // play nice with scrolling
                        buildDefaultDragHandles: false,
                        itemCount: _sectionItems.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(_sectionItems[index].name),
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
                                removeItem(_sectionItems[index]);
                                return true;
                              }
                              return false;
                            },
                            child: ListTile(
                              onTap: () => navigateToItemEditScreen(
                                  _sectionItems[index]),
                              title: Text(_sectionItems[index].name),
                              trailing: const Icon(Icons.arrow_right_alt),
                              leading: ReorderableDragStartListener(
                                index: index,
                                child: Icon(
                                  Icons.drag_handle,
                                  color: Theme.of(context).colorScheme.surface,
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
                            final item = _sectionItems.removeAt(oldIndex);
                            _sectionItems.insert(newIndex, item);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              // hide when keyboard visible
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSection,
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
