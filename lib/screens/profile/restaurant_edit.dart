import 'package:bon_appetit_app/models/partner_models.dart';
import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_details.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantEditScreen extends ConsumerStatefulWidget {
  const RestaurantEditScreen({super.key, this.restaurant});

  final PartnerRestaurant? restaurant;

  @override
  ConsumerState<RestaurantEditScreen> createState() =>
      _RestaurantEditScreenState();
}

class _RestaurantEditScreenState extends ConsumerState<RestaurantEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? restaurantId;
  var _enteredName = '';
  var _enteredSpecialty = '';
  var _enteredDescription = '';
  var _enteredPhoneNumber = '11912345678';

  var _enteredStreet = 'Av. Brasil';
  var _enteredStreetNumber = '1234';
  var _enteredZipCode = '01345-678';
  var _enteredCity = 'São Paulo';
  var _enteredDistrict = '';
  var _enteredState = 'São Paulo';
  var _enteredCountry = 'Brasil';

  @override
  void initState() {
    super.initState();

    if (widget.restaurant != null) {
      setState(() {
        restaurantId = widget.restaurant!.id;

        _enteredName = widget.restaurant!.title;
        _enteredSpecialty = widget.restaurant!.specialty;
        _enteredDescription = widget.restaurant!.description;
        _enteredPhoneNumber = widget.restaurant!.phoneNumber;

        _enteredStreet = widget.restaurant!.address!.streetName;
        _enteredStreetNumber = widget.restaurant!.address!.streetNumber;
        _enteredZipCode = widget.restaurant!.address!.zipCode;
        _enteredCity = widget.restaurant!.address!.city;
        _enteredDistrict = widget.restaurant!.address!.district;
        _enteredState = widget.restaurant!.address!.state;
        _enteredCountry = widget.restaurant!.address!.country;
      });
    }
  }

  void _saveRestaurant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var address = Address(
          _enteredCountry,
          _enteredState,
          _enteredCity,
          _enteredDistrict,
          _enteredStreet,
          _enteredStreetNumber,
          _enteredZipCode);
      var partner = PartnerRestaurant("", _enteredName, _enteredDescription,
          _enteredSpecialty, _enteredPhoneNumber, true, address);

      if (restaurantId != null) {
        // edit
        var result = await BonAppetitApiService().putUpdatePartner(
            restaurantId!, partner,
            token: ref.read(authProvider).token);
        if (result) {
          if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        }
      } else {
        // new
        var partnerId = await BonAppetitApiService()
            .postCreatePartner(partner, token: ref.read(authProvider).token);
        if (partnerId != null) {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) =>
                    RestaurantDetailsScreen(restaurantId: partnerId)));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var specialties = {
      "Italiana": "Italiana",
      "Brasileira": "Brasileira",
      "Japonesa": "Japonesa",
      "Chinesa": "Chinesa",
      "Lanches": "Lanches",
      "Saudável": "Saúdavel",
      "Pizza": "Pizza"
    };

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
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      DropdownButtonFormField(
                        decoration:
                            const InputDecoration(label: Text('Especialidade')),
                        value: specialties.containsValue(_enteredSpecialty)
                            ? _enteredSpecialty
                            : specialties.entries.first.value,
                        items: specialties.entries
                            .map((e) => DropdownMenuItem<String>(
                                value: e.value, child: Text(e.key)))
                            .toList(),
                        onSaved: (value) {
                          _enteredSpecialty = value!;
                        },
                        onChanged: (value) => {
                          setState(() {
                            _enteredSpecialty = value!;
                          })
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredDescription,
                        maxLength: 150,
                        maxLines: 3,
                        decoration:
                            const InputDecoration(label: Text('Descrição')),
                        onSaved: (value) {
                          _enteredDescription = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredPhoneNumber,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Telefone')),
                        onSaved: (value) {
                          _enteredPhoneNumber = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredStreet,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Endereço')),
                        onSaved: (value) {
                          _enteredStreet = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredStreetNumber,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Número')),
                        onSaved: (value) {
                          _enteredStreetNumber = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredDistrict,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Bairro')),
                        onSaved: (value) {
                          _enteredDistrict = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredZipCode,
                        maxLength: 100,
                        decoration: const InputDecoration(label: Text('CEP')),
                        onSaved: (value) {
                          _enteredZipCode = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredCity,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Cidade')),
                        onSaved: (value) {
                          _enteredCity = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredState,
                        maxLength: 100,
                        decoration:
                            const InputDecoration(label: Text('Estado')),
                        onSaved: (value) {
                          _enteredState = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _enteredCountry,
                        maxLength: 100,
                        decoration: const InputDecoration(label: Text('País')),
                        onSaved: (value) {
                          _enteredCountry = value!;
                        },
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
