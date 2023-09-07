import 'dart:convert';

import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  Future<List> getRestaurants() async {
    var url = Uri.parse('http://10.0.2.2:7080/public/restaurants');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error loading restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image.asset('images/bonappetit_logo.png'),
          const SizedBox(height: 24),
          const Text(
            'Leia o QR code para visualizar o cardápio ou escolha um restaurante disponível da lista abaixo',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Restaurantes Disponíveis',
            style: Theme.of(context).textTheme!.headlineSmall,
          ),
          FutureBuilder<List>(
            future: getRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Erro ao carregar restaurantes"),
                );
              }

              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          
                        },
                        title: Text(snapshot.data![index]['name']),
                        subtitle: Text(snapshot.data![index]['address']),
                      );
                    });
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
