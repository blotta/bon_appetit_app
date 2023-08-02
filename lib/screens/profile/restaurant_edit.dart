import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_details.dart';
import 'package:flutter/material.dart';

class RestaurantEditScreen extends StatefulWidget {
  const RestaurantEditScreen({super.key, this.restaurant});

  final Restaurant? restaurant;

  @override
  State<RestaurantEditScreen> createState() => _RestaurantEditScreenState();
}

class _RestaurantEditScreenState extends State<RestaurantEditScreen> {

  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredAddress = '';

  @override
  void initState() {
    super.initState();

    if (widget.restaurant != null) {
      setState(() {
        _enteredName = widget.restaurant!.name;
        _enteredAddress = widget.restaurant!.address;
      });
    }
  }

  void _saveRestaurant() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.restaurant != null) {
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
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.surface,
          backgroundColor: Colors.white,
          title:
              Text(widget.restaurant == null ? 'Novo Restaurante' : 'Editar'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        initialValue: _enteredName,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text('Nome')),
                      ),
                      TextFormField(
                        initialValue: _enteredAddress,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Endereço')),
                      ),
                      const SizedBox(height: 50),
                    ]),
                  ),
                ),
              ),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom ==
                    0, // hide when keyboard visible
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRestaurant,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                    child: Text(widget.restaurant == null ? 'CRIAR' : 'SALVAR'),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
