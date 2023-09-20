import 'package:bon_appetit_app/models/payment.dart';
import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:flutter/material.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key});

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  @override
  Widget build(BuildContext context) {
    returnWithCardInfo(
        String cardNumber, String name, String cvv, String validate) {
      var cc = CreditCard(name, cardNumber, cvv, validate);
      Navigator.of(context).pop(cc);
    }

    final buttonDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).colorScheme.surface,
    );

    var buttonTextStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CreditCardInputForm(
          prevButtonDecoration: buttonDecoration,
          nextButtonDecoration: buttonDecoration,
          prevButtonTextStyle: buttonTextStyle,
          nextButtonTextStyle: buttonTextStyle,
          resetButtonTextStyle: buttonTextStyle,
          customCaptions: const {
            "NEXT": "Próximo",
            "PREV": "Anterior",
            "DONE": "OK",
            'CARD_NUMBER': 'Número do cartão',
            'CARDHOLDER_NAME': 'Nome do cartão',
            'VALID_THRU': 'Válido até',
            'SECURITY_CODE_CVC': 'CVC',
            'NAME_SURNAME': 'Nome Sobrenome',
            'MM_YY': 'MM/YY',
            'RESET': 'Resetar',
          },
          onStateChange: (currentState, cardInfo) {
            if (currentState == InputState.DONE &&
                cardInfo.cardNumber != null &&
                cardInfo.cardNumber.toString().isNotEmpty &&
                cardInfo.name != null &&
                cardInfo.name.toString().isNotEmpty &&
                cardInfo.cvv != null &&
                cardInfo.cvv.toString().isNotEmpty &&
                cardInfo.validate != null &&
                cardInfo.validate.toString().isNotEmpty) {
              returnWithCardInfo(cardInfo.cardNumber, cardInfo.name,
                  cardInfo.cvv, cardInfo.validate);
            }
          },
        ),
      ]),
    );
  }
}
