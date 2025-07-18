import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/provider/gym_package_provider.dart';
import 'package:schedulerapp/provider/trainee_provider.dart';

class AddClientModal extends StatefulWidget {
  const AddClientModal({super.key});

  @override
  State<AddClientModal> createState() => _AddClientModalState();
}

class _AddClientModalState extends State<AddClientModal> {
  final _nameController = TextEditingController();
  final _packageNameTextController = TextEditingController();
  final _noOfSessionTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //final StorageService _storageService = GetIt.I<StorageService>();

  String? _nameError;
  String? _packageNameError;
  String? _noOfSessionError;
  String? _priceError;
  String? _selectedAvatar = traineeAvatarImageUrls.first;
  GymPackage? _selectedPackage;

  @override
  void dispose() {
    _nameController.dispose();

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
          'Add New Trainee',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      child: contentIos(),
    );
  }

  contentIos() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: SingleChildScrollView(child: formContent()),
          ),
        ],
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
            _textFieldLabel('Choose Avatar'),
            avatarList(),
            const SizedBox(height: 16.0),
            _textFieldLabel('Client\'s Name:'),
            _cupertinoTextField(_nameController, 'Enter Client\'s full name'),
            _nameError != null
                ? _errorMessageWidget(_nameError!)
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            _textFieldLabel('Training Packages'),
            _trainingPackageList(),
            ..._packageFormfields(),
            const SizedBox(height: 24.0),
            _saveTraineeButton(),
          ],
        ),
      ),
    );
  }

  Padding _errorMessageWidget(errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  _cupertinoTextField(textController, placeHolder) {
    return CupertinoTextField(
      controller: textController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      placeholder: placeHolder,
      decoration: BoxDecoration(
        color: coloGreyShadeFour,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  _textFieldLabel(label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 15, color: colorBlackTwo),
      ),
    );
  }

  _trainingPackageList() {
    return Consumer<GymPackageProvider>(
      builder: (context, gymPackageProvider, child) {
        if (gymPackageProvider.error != null) {
          return Center(
            child: Text(
              'Error loading packages: ${gymPackageProvider.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        var packages = gymPackageProvider.gymPackages;
        if (gymPackageProvider.isLoading ||
            packages == null ||
            packages.isEmpty) {
          return _trainingPackageListView([
            GymPackage('', 'New Package', 0, 0.0, 0, 'traineeId'),
          ]);
        }
        var allPackages = [
          GymPackage('', 'New Package', 0, 0.0, 0, 'traineeId'),
          ...packages,
        ];
        return _trainingPackageListView(allPackages);
      },
    );
  }

  _trainingPackageListView(List<GymPackage> packages) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool isSelected =
              _selectedPackage != null &&
              _selectedPackage!.name == packages[index].name;
          return GestureDetector(
            onTap: () {
              String packageName = packages[index].name;
              setState(() => _selectedPackage = packages[index]);
              _packageNameTextController.text = packageName;
              _priceTextController.text = packages[index].cost.toString();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected ? colorGreyTwo : colorGreyShadeFive,
              ),
              child: Center(
                child: Text(
                  packages[index].name,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : colorBlackTwo,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemCount: packages.length,
      ),
    );
  }

  _saveTraineeButton() {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: _saveTrainee,
        style: TextButton.styleFrom(
          backgroundColor: colorBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Save Client',
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
        itemCount: traineeAvatarImageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedAvatar = traineeAvatarImageUrls[index]);
              },
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          traineeAvatarImageUrls[index].isNotEmpty
                              ? AssetImage(traineeAvatarImageUrls[index])
                              : null,
                    ),
                  ),
                  _selectedAvatar == traineeAvatarImageUrls[index]
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

  _saveTrainee() async {
    if (_formValidate()) {
      final name = _nameController.text;

      var newTrainee = Trainee(UniqueKey().toString(), name, _selectedAvatar);
      await Provider.of<TraineeProvider>(
        context,
        listen: false,
      ).saveTrainee(newTrainee);

      Provider.of<GymPackageProvider>(context, listen: false).saveGymPackage(
        _packageNameTextController.text == 'New Package'
            ? 'Package for $name'
            : _packageNameTextController.text,
        int.parse(_noOfSessionTextController.text),
        double.parse(_priceTextController.text),
        newTrainee.id,
      );

      showCupertinoDialog(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: Text('Success'),
              content: Text('New Client added.'),
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

  _formValidate() {
    _nameError = null;
    _priceError = null;
    _packageNameError = null;
    _noOfSessionError = null;

    if (_nameController.text.isEmpty) {
      _nameError = 'Please enter the name';
    }
    if (_packageNameTextController.text.isEmpty) {
      _packageNameError = 'Please enter the package name';
    }
    if (_noOfSessionTextController.text.isEmpty) {
      _noOfSessionError = 'Please enter the number of sessions';
    }
    if (_priceTextController.text.isEmpty) {
      _priceError = 'Please enter the package price';
    } else {
      try {
        double.parse(_priceTextController.text);
      } catch (e) {
        _priceError = 'Please enter a valid price';
      }
    }

    setState(() {});

    return _nameError == null &&
        _priceError == null &&
        _packageNameError == null &&
        _noOfSessionError == null &&
        _selectedPackage != null;
  }

  List<Widget> _packageFormfields() {
    List<Widget> packageFields = [];
    bool isCustomPackageSelected =
        _selectedPackage != null && _selectedPackage!.name == 'New Package';
    bool isPackageSelected = _selectedPackage != null;
    if (isCustomPackageSelected) {
      packageFields.addAll([
        const SizedBox(height: 16.0),
        _textFieldLabel('Package Name'),
        _cupertinoTextField(_packageNameTextController, 'Enter package name'),
        _packageNameError != null
            ? _errorMessageWidget(_packageNameError!)
            : const SizedBox.shrink(),
      ]);
    }
    if (isPackageSelected) {
      packageFields.addAll([
        const SizedBox(height: 16.0),
        _textFieldLabel('Price'),
        _cupertinoTextField(_priceTextController, 'Enter package price'),
        _priceError != null
            ? _errorMessageWidget(_priceError!)
            : const SizedBox.shrink(),
        const SizedBox(height: 16.0),
        _textFieldLabel('Number of Sessions'),
        _cupertinoTextField(
          _noOfSessionTextController,
          'Enter number of sessions',
        ),
        _noOfSessionError != null
            ? _errorMessageWidget(_noOfSessionError!)
            : const SizedBox.shrink(),
      ]);
    }
    return packageFields;
  }
}
