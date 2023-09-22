import 'dart:async';

import 'package:bon_appetit_app/models/payment.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentProcessScreen extends ConsumerWidget {
  const PaymentProcessScreen(
      {super.key, required this.creditCard, required this.orderNumber});

  final int orderNumber;
  final CreditCard creditCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    attemptPayment() {
      BonAppetitApiService()
          .postMakePayment(orderNumber, creditCard)
          .then((value) => Navigator.of(context).pop<bool>(value))
          .catchError((e) => Navigator.of(context).pop<bool>(false));
    }

    Timer(const Duration(milliseconds: 1000), attemptPayment);

    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
              alignment: Alignment.center, child: CircularProgressIndicator()),
          SizedBox(
            height: 30,
          ),
          Text(
            'Realizando o pagamento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
