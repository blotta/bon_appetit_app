import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter/material.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key, this.returnItemBehaviour = false});

  final bool returnItemBehaviour;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final itemNameController = TextEditingController();
  List<MenuItem> searchItems = [];

  @override
  void initState() {
    super.initState();
    itemNameController.addListener(_search);

    _search();
  }

  void navigateToItemEditScreen(MenuItem? item) {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (ctx) => ItemEditScreen(item: item)));
  }

  void _search() {
    if (itemNameController.text.isEmpty || itemNameController.text == '') {
      setState(() {
        searchItems = [...dataItems];
      });
      return;
    }

    setState(() {
      searchItems = dataItems
          .where((i) => i.name
              .toLowerCase()
              .contains(itemNameController.text.toLowerCase()))
          .toList();
    });
  }

  void returnItem(MenuItem item) {
    Navigator.of(context).pop(item);
  }

  @override
  void dispose() {
    itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: const Text('Itens'),
        actions: [
          IconButton(
            onPressed: () => navigateToItemEditScreen(null),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              // onChanged: (text) => _search,
              decoration: InputDecoration(
                  hintText: 'Pesquisa',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false, // play nice with scrolling
                      itemCount: searchItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => returnItem(searchItems[index]),
                          title: Text(searchItems[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => navigateToItemEditScreen(searchItems[index]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
