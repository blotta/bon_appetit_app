import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/screens/profile/product_edit.dart';
import 'package:bon_appetit_app/screens/profile/items.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionEditScreen extends ConsumerStatefulWidget {
  const SectionEditScreen(
      {super.key, required this.section, required this.menuId});

  final String menuId;
  final DMenuSection section;

  @override
  ConsumerState<SectionEditScreen> createState() => _SectionEditScreenState();
}

class _SectionEditScreenState extends ConsumerState<SectionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  List<DProduct> _sectionProducts = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _enteredName = widget.section.name;
      _sectionProducts = widget.section.products;
    });
  }

  void _saveSection() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.of(context).pop();
    }
  }

  void navigateToItemsScreenAndGetItem() async {
    var newProduct = await Navigator.of(context).push<DProduct>(
        MaterialPageRoute(
            builder: (ctx) => const ItemsScreen(returnItemBehaviour: true)));

    if (newProduct != null &&
        !_sectionProducts.any((i) => i.name == newProduct.name)) {
      setState(() {
        _sectionProducts.add(newProduct);
      });
    }
  }

  navigateToItemEditScreen(DProduct? product) async {
    var newProduct = await Navigator.of(context).push<DProduct?>(
        MaterialPageRoute(
            builder: (ctx) => ProductEditScreen(
                menuId: widget.menuId,
                sectionId: widget.section.id,
                product: product)));
    if (newProduct != null) {
      setState(() {
        _sectionProducts.add(newProduct);
      });
    }
  }

  Future<bool> deleteProduct(DProduct product) async {
    var prodId = await BonAppetitApiService().deleteMenuSectionProduct(
        widget.menuId, widget.section.id, product.id,
        token: ref.read(authProvider).token);
    if (prodId != null) {
      _sectionProducts.remove(product);
      return true;
    }
    if (context.mounted) {
      showErrorSnackbar(context, "Erro ao deletar produto");
    }
    return false;
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
                        readOnly: true,
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
                            onPressed: () => navigateToItemEditScreen(null),
                            icon: const Icon(Icons.add_box, size: 30),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ],
                      ),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        primary: false, // play nice with scrolling
                        buildDefaultDragHandles: false,
                        itemCount: _sectionProducts.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(_sectionProducts[index].name),
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
                                var success =
                                    deleteProduct(_sectionProducts[index]);
                                return success;
                              }
                              return false;
                            },
                            child: ListTile(
                              onTap: () => navigateToItemEditScreen(
                                  _sectionProducts[index]),
                              title: Text(_sectionProducts[index].name),
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
                            final item = _sectionProducts.removeAt(oldIndex);
                            _sectionProducts.insert(newIndex, item);
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
