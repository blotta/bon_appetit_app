import 'dart:io';

import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemEditScreen extends StatefulWidget {
  const ItemEditScreen({super.key, this.item});

  final MenuItem? item;

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredImageUrl = '';
  var _enteredDescription = '';
  double _enteredPrice = 0;
  XFile? pickedImage;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      setState(() {
        _enteredName = widget.item!.name;
        _enteredImageUrl = widget.item!.imageUrl;
        _enteredDescription = widget.item!.description;
        _enteredPrice = widget.item!.price;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.item != null) {
        // edit
      } else {
        // new
        var item = MenuItem(
            _enteredName, _enteredImageUrl, _enteredPrice, _enteredDescription);
        dataItems.add(item);
      }
      Navigator.of(context).pop();
    }
  }

  void getImage() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        pickedImage = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageInput = Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey,
      child: const Center(
          child: Icon(
        Icons.image_search,
        color: Colors.black54,
        size: 80,
      )),
    );

    if (pickedImage != null) {
      imageInput = FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: FileImage(File(pickedImage!.path)),
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      );
    } else if (_enteredImageUrl != '') {
      imageInput = FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(_enteredImageUrl),
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: Text(widget.item == null ? 'Novo Item' : 'Editar Item'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    InkWell(
                      onTap: () => getImage(),
                      child: imageInput,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        initialValue: _enteredName,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text('Título')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                          initialValue: _enteredDescription,
                          maxLength: 200,
                          maxLines: 3,
                          decoration:
                              const InputDecoration(label: Text('Descrição'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextFormField(
                        initialValue: _enteredPrice.toStringAsFixed(2),
                        maxLength: 50,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: const Text('Preço'),
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ]),
                ),
              ),
          ),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom ==
                0, // hide when keyboard visible
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  child: Text(widget.item == null ? 'CRIAR' : 'SALVAR'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
