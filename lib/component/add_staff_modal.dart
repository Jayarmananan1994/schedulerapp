import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/exception/resource_creation_exception.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/service/storage_service.dart';

class AddStaffModal extends StatefulWidget {
  const AddStaffModal({super.key});

  @override
  State<AddStaffModal> createState() => _AddStaffModalState();
}

class _AddStaffModalState extends State<AddStaffModal> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = GetIt.I<StorageService>();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[appBar(), Expanded(child: formContent())],
    );
  }

  appBar() {
    return Material(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(top: 52),
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 50),
            const Text(
              'Add new trainer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  formContent() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name ';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price ';
                  }
                  final duration = double.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per session',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveTrainer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTrainer() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = _priceController.text;
      var newStaff = Staff(
        id: UniqueKey().toString(),
        name: name,
        payRate: double.parse(price),
      );
      if (name.isNotEmpty && price.isNotEmpty) {
        try {
          _storageService.saveTrainer(newStaff).then((value) {
            showCupertinoDialog(
              context: context,
              builder:
                  (context) => CupertinoAlertDialog(
                    title: Text('Success'),
                    content: Text('New Trainer added.'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
            ).then((_) {
              Navigator.pop(context, true);
            });
          });
        } on ResourceCreationException catch (e) {
          showCupertinoDialog(
            context: context,
            builder:
                (context) => CupertinoAlertDialog(
                  title: Text('Error', style: TextStyle(color: Colors.red)),
                  content: Text('Failed to create new Trainer'),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
          ).then((_) {
            Navigator.pop(context, true);
          });
        }
      }
    }
  }
}
