import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/component/add_package_dialog.dart';
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
      height: 90.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 5.0),
        itemBuilder: (context, index) {
          if (index < packages.length) {
            final package = packages[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPackage = package;
                });
                widget.onPackageSelect(_selectedPackage);
              },
              child: SizedBox(
                width: 100.0,
                child: Card(
                  color:
                      _selectedPackage == package
                          ? Color(0xffEFF6FF)
                          : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${package.noOfSessionsAvailable}',
                              style: const TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' Avl',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '\$${package.cost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
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
              child: InkWell(
                onTap: _showAddSessionDialog,
                child: Card(
                  color: Colors.deepPurple[100],
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
        result['sessions'],
        result['cost'],
        widget.trainee.id,
      );

      setState(() {});
    }
  }
}
