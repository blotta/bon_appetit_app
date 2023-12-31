import 'dart:io';
import 'dart:typed_data';

import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:bon_appetit_app/utils/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductEditScreen extends ConsumerStatefulWidget {
  const ProductEditScreen(
      {super.key, this.product, required this.menuId, required this.sectionId});

  final String menuId;
  final String sectionId;
  final DProduct? product;

  @override
  ConsumerState<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends ConsumerState<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _enteredName = TextEditingController();
  final _enteredImageUrl = TextEditingController();
  final _enteredDescription = TextEditingController();
  final _enteredPrice = TextEditingController();
  XFile? pickedImage;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _enteredPrice.text = (0).toStringAsFixed(2);

    if (widget.product != null) {
      setState(() {
        _enteredName.text = widget.product!.name;
        _enteredDescription.text = widget.product!.description;
        _enteredPrice.text = widget.product!.price.toStringAsFixed(2);
        _enteredImageUrl.text = widget.product!.imageUrl ?? '';
      });
    }
  }

  Future<bool> _uploadProductImage(String productId, Uint8List pngBytes) async {
    var success = await BonAppetitApiService().uploadMenuSectionProductImage(
        widget.menuId, widget.sectionId, productId, pngBytes,
        token: ref.read(authProvider).token);
    return success;
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.product != null) {
        // edit
        if (pickedImage != null) {
          var success = await _uploadProductImage(
              widget.product!.id, await pickedImage!.readAsBytes());
          if (!success) {
            if (context.mounted) {
              showErrorSnackbar(context, "Erro ao enviar imagem");
            }
          }
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return;
      } else {
        // new
        var product = DProduct(
            '',
            _enteredName.text,
            _enteredDescription.text,
            // _enteredImageUrl,
            double.parse(_enteredPrice.text),
            '');
        loadingDialog(context, "Enviando...");
        var newProductId = await BonAppetitApiService()
            .postCreateMenuSectionProduct(
                widget.menuId, widget.sectionId, product,
                token: ref.read(authProvider).token);
        if (context.mounted) {
          Navigator.of(context).pop(); // loadingDialog
        }
        if (newProductId != null) {
          if (pickedImage != null) {
            var pngBytes = await pickedImage!.readAsBytes();
            var success = await _uploadProductImage(newProductId, pngBytes);
            if (!success) {
              if (context.mounted) {
                showErrorSnackbar(context, "Erro ao enviar imagem");
              }
            }
          }

          var newProduct = DProduct(newProductId, _enteredName.text,
              _enteredDescription.text, double.parse(_enteredPrice.text), null);
          if (context.mounted) {
            Navigator.of(context).pop<DProduct>(newProduct);
          }

          return;
        }
      }
      if (context.mounted) {
        showErrorSnackbar(context, "Erro ao salvar produto");
      }
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
  void dispose() {
    _enteredName.dispose();
    _enteredDescription.dispose();
    _enteredImageUrl.dispose();
    _enteredPrice.dispose();
    super.dispose();
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
    } else if (_enteredImageUrl.text != '') {
      imageInput = FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(_enteredImageUrl.text),
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: Text(widget.product == null ? 'Novo Item' : 'Editar Item'),
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
                      controller: _enteredName,
                      readOnly: widget.product != null,
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Título')),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Título inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _enteredDescription,
                      readOnly: widget.product != null,
                      maxLength: 200,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(label: Text('Descrição')),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Descrição inválida";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _enteredPrice,
                      readOnly: widget.product != null,
                      maxLength: 50,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Preço'),
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preço inválido";
                        }
                        var number = double.tryParse(value);
                        if (number == null || number < 0) {
                          return "Preço inválido";
                        }
                        return null;
                      },
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
                  child: Text(widget.product == null ? 'CRIAR' : 'SALVAR'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
