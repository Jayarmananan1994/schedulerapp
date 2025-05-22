import 'package:flutter/cupertino.dart';

class AddPackageDialog extends StatefulWidget {
  const AddPackageDialog({super.key});

  @override
  State<AddPackageDialog> createState() => _AddPackageDialogState();
}

class _AddPackageDialogState extends State<AddPackageDialog> {
  final TextEditingController _sessionsController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a numeric value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Add New Package'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            CupertinoTextFormFieldRow(
              prefix: const Text('Sessions: No.'),
              controller: _sessionsController,
              keyboardType: TextInputType.number,
              validator: _validateNumeric,
            ),
            CupertinoTextFormFieldRow(
              prefix: const Text('Cost: \$'),
              controller: _costController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: _validateNumeric,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Add'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final sessions = int.tryParse(_sessionsController.text);
              final cost = double.tryParse(_costController.text);
              if (sessions != null && cost != null) {
                Navigator.of(context).pop({'sessions': sessions, 'cost': cost});
              }
            }
          },
        ),
      ],
    );
  }
}
