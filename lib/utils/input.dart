import 'package:flutter/material.dart';

Future<String?> getStringDialog(
    BuildContext context,
    TextEditingController controller,
    GlobalKey<FormState> formKey,
    String title,
    String hintText) async {
  controller.clear();
  return await showDialog<String?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nome Inválido";
                        }
                        return null;
                      },
                      decoration: InputDecoration(hintText: hintText),
                    ),
                  ],
                )),
            title: Text(title),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop<String>(controller.text);
                  }
                },
              ),
            ],
          );
        });
      });
}

Future<bool> confirmDialog(BuildContext context, String content,
    {String? yesText, String? noText}) async {
  var alert = AlertDialog(
    content: Text(content),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(noText ?? 'Não'),
      ),
      ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yesText ?? 'Sim',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white)))
    ],
  );
  return await showDialog(
      context: context,
      builder: (ctx) {
        return alert;
      });
}

// call Navigator.of(context).pop(); after
loadingDialog(
  BuildContext context,
  String? title,
) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: Text(title ?? 'Enviando...'),
        )
      ],
    ),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
