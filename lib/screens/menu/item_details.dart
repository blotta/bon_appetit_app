import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(item.name),
      ),
      body: Column(
        children: [
          Image.network(
            item.imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('\$ ${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
