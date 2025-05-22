import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/component/add_client_modal.dart';
import 'package:schedulerapp/component/client_detail_modal.dart';
import 'package:schedulerapp/entity/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class TraineeListScreen extends StatefulWidget {
  const TraineeListScreen({super.key});

  @override
  State<TraineeListScreen> createState() => _TraineeListScreenState();
}

class _TraineeListScreenState extends State<TraineeListScreen> {
  final StorageService _storageService = GetIt.I<StorageService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Trainee>>(
        future: _storageService.getTraineeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No clients available. Add new ones.'),
            );
          } else {
            final traineeList = snapshot.data!;
            return ListView.builder(
              itemCount: traineeList.length,
              itemBuilder: (context, index) {
                final trainee = traineeList[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Text(
                      trainee.name[0],
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  title: Text(trainee.name),
                  onTap: () => _showTraineeDetail(trainee),
                  subtitle: _traineePackageDetail(trainee),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStaffDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showAddStaffDialog() async {
    var isSaved = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddClientModal(),
    );
    if (isSaved != null && isSaved) {
      setState(() {});
    }
  }

  _showTraineeDetail(Trainee staff) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ClientDetailModal(trainee: staff);
      },
    ).then((isPckAdded) {
      if (isPckAdded) {
        setState(() {});
      }
    });
  }

  _traineePackageDetail(Trainee trainee) {
    final packages = _storageService.getTraineeActivePackages(trainee);
    final pkgDetailText =
        packages.isEmpty
            ? 'No Package available'
            : packages
                .mapIndexed(
                  (index, pkg) =>
                      'PKG-${index + 1}: ${pkg.noOfSessionsAvailable} sessions@\$${pkg.cost}',
                )
                .join(',');
    return Text(pkgDetailText, overflow: TextOverflow.ellipsis);
  }
}
