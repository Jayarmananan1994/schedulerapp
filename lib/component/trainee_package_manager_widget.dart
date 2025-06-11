import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/add_package_dialog.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/entity/gym_package.dart';
import 'package:schedulerapp/entity/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class TraineePackageManagerWidget extends StatefulWidget {
  final Trainee trainee;
  final Function onPackageSelect;
  const TraineePackageManagerWidget({
    super.key,
    required this.trainee,
    required this.onPackageSelect,
  });

  @override
  State<TraineePackageManagerWidget> createState() =>
      _TraineePackageManagerWidgetState();
}

class _TraineePackageManagerWidgetState
    extends State<TraineePackageManagerWidget> {
  final _storageService = GetIt.I<StorageService>();
  GymPackage? _selectedPackage;

  @override
  Widget build(BuildContext context) {
    return traineeSessionsForm();
  }

  traineeSessionsForm() {
    final packages = _storageService.getTraineeActivePackages(widget.trainee);
    if (packages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No package available'),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: _showAddSessionDialog,
              child: Text('Add Package'),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 100.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 5.0),
        itemBuilder: (context, index) {
          if (index < packages.length) {
            final package = packages[index];
            return GestureDetector(
              onTap: () {
                setState(() => _selectedPackage = package);
                widget.onPackageSelect(_selectedPackage);
              },
              child: SizedBox(
                width: 200.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color:
                        _selectedPackage == package
                            ? Color(0xffEFF6FF)
                            : Colors.white,
                    border: Border.all(
                      color:
                          _selectedPackage == package
                              ? Color(0xff4A90E2)
                              : Color(0xffE5E7EB),
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              package.name,
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            _selectedPackage == package
                                ? Icon(
                                  Icons.check_circle,
                                  color: Color(0xff4A90E2),
                                  size: 20,
                                )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          '${package.noOfSessionsAvailable} sessions remaining',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: colorGreyTwo,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          '\$${package.cost.toStringAsFixed(2)}/session',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: colorGreyTwo,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              width: 80.0,
              child: GestureDetector(
                onTap: _showAddSessionDialog,
                child: Card(
                  color:
                      CupertinoColors
                          .systemBackground, //Colors.deepPurple[100],
                  child: const Center(child: Icon(Icons.add)),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _showAddSessionDialog() async {
    final result = await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => const AddPackageDialog(),
    );

    if (result != null && result is Map<String, dynamic>) {
      await _storageService.addNewPackageToTrainee(
        'Custom Package',
        result['sessions'],
        result['cost'],
        widget.trainee.id,
      );

      setState(() {});
    }
  }
}
