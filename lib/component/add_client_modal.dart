import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/model/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class AddClientModal extends StatefulWidget {
  const AddClientModal({super.key});

  @override
  State<AddClientModal> createState() => _AddClientModalState();
}

class _AddClientModalState extends State<AddClientModal> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _sessionsPurchased = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _storageService = GetIt.I<StorageService>();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _sessionsPurchased.dispose();
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
              'Add new Client',
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        (value != null &&
                                value.isNotEmpty &&
                                double.tryParse(value) == null)
                            ? 'Please enter a valid fee per session'
                            : null,
                decoration: const InputDecoration(
                  labelText: 'Fee per session',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _sessionsPurchased,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        (value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null)
                            ? 'Please enter a valid session count'
                            : null,
                decoration: const InputDecoration(
                  labelText: 'Sessions purchased',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),

              ElevatedButton(
                onPressed: _createNewClient,
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

  void _createNewClient() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = _priceController.text;
      final sessionsPurchased = _sessionsPurchased.text;
      if (name.isNotEmpty) {
        final newTrainee = Trainee(
          id: UniqueKey().toString(),
          name: name,
          feePerSession: price.isEmpty ? 0 : double.parse(price),
          sessionsLeft:
              sessionsPurchased.isEmpty ? 0 : int.parse(sessionsPurchased),
        );

        var isSaved = await _storageService.saveTrainee(newTrainee);

        postSaveActivity(isSaved);
      }
    }
  }

  postSaveActivity(bool isSaved) {
    String message =
        _sessionsPurchased.text == ''
            ? 'Client added. You can adde sessions to the client later from 2nd Tab'
            : 'New Client added';
    if (isSaved) {
      _nameController.clear();
      _priceController.clear();
      _sessionsPurchased.clear();
      showAppInfoDialog(
        context,
        'Client added',
        message,
        'Ok',
        false,
      ).then((value) => Navigator.pop(context, true));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving client. Please try again.')),
      );
    }
  }
}
