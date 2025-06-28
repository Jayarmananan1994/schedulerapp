import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';
import 'package:schedulerapp/util/dialog_util.dart';

class AddTrainerModal extends StatefulWidget {
  const AddTrainerModal({super.key});

  @override
  State<AddTrainerModal> createState() => _AddTrainerModalState();
}

class _AddTrainerModalState extends State<AddTrainerModal> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _roleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _nameError;
  String? _priceError;
  String? _selectedAvatar = trainerAvatarImageUrls.first;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        middle: Text(
          'Add New Trainer',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      child: contentIos(),
    );
  }

  contentIos() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [SliverFillRemaining(child: formContent())],
      ),
    );
  }

  formContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Choose Avatar',
                style: GoogleFonts.inter(fontSize: 15, color: colorBlackTwo),
              ),
            ),
            avatarList(),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Trainer\'s Name',
                style: GoogleFonts.inter(fontSize: 15, color: colorBlackTwo),
              ),
            ),
            CupertinoTextField(
              controller: _nameController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              placeholder: 'Enter trainer\'s full name',
              decoration: BoxDecoration(
                color: coloGreyShadeFour,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            _nameError != null
                ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _nameError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Pay per session',
                style: GoogleFonts.inter(fontSize: 15, color: colorBlackTwo),
              ),
            ),
            _textField(_priceController, 'Enter price per session'),
            _priceError != null
                ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _priceError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Title',
                style: GoogleFonts.inter(fontSize: 15, color: colorBlackTwo),
              ),
            ),
            _textField(_roleController, 'e.g. Fitness Coach, Yoga Instructor'),

            const SizedBox(height: 24.0),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  CupertinoTextField _textField(controller, placeholder) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: coloGreyShadeFour,
        borderRadius: BorderRadius.circular(8.0),
      ),
      keyboardType: TextInputType.text,
    );
  }

  _submitButton() {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: _saveTrainer,
        style: TextButton.styleFrom(
          backgroundColor: colorBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Save Trainer',
          style: GoogleFonts.inter(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  avatarList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trainerAvatarImageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedAvatar = trainerAvatarImageUrls[index]);
              },
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          trainerAvatarImageUrls[index].isNotEmpty
                              ? AssetImage(trainerAvatarImageUrls[index])
                              : null,
                    ),
                  ),
                  _selectedAvatar == trainerAvatarImageUrls[index]
                      ? Positioned(
                        top: 0,
                        left: 50,
                        right: 0,
                        bottom: 60,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 30,
                        ),
                      )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _saveTrainer() {
    if (_formValidate()) {
      final name = _nameController.text;
      final price = _priceController.text;
      var newTrainer = Trainer(
        UniqueKey().toString(),
        name,
        double.parse(price),
        _selectedAvatar,
        _roleController.text,
      );

      context
          .read<TrainerProvider>()
          .addStaff(newTrainer)
          .then((value) async {
            if (!value) {
              await showAppInfoDialog(
                context,
                'Error',
                'Failed to create new Trainer',
                'Ok',
                true,
              );
              return;
            }
            showAppInfoDialog(
              context,
              'Success',
              'New Trainer added.',
              'Ok',
              false,
            );
            Navigator.pop(context, true);
          })
          .catchError((error) async {
            await showCupertinoDialog(
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
            );
            Navigator.pop(context, false);
          });
    }
  }

  _formValidate() {
    _nameError = null;
    _priceError = null;

    if (_nameController.text.isEmpty) {
      _nameError = 'Please enter the name';
    }

    if (_priceController.text.isEmpty) {
      _priceError = 'Please enter the price';
    } else {
      final price = double.tryParse(_priceController.text);
      if (price == null || price <= 0) {
        _priceError = 'Please enter a valid price';
      }
    }

    setState(() {});

    return _nameError == null && _priceError == null;
  }
}
