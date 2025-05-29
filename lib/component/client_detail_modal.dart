import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/component/add_package_dialog.dart';
import 'package:schedulerapp/component/client_schedule_history_list.dart';
import 'package:schedulerapp/component/client_upcoming_schedules_list.dart';
import 'package:schedulerapp/entity/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ClientDetailModal extends StatefulWidget {
  final Trainee trainee;
  const ClientDetailModal({super.key, required this.trainee});

  @override
  State<ClientDetailModal> createState() => _ClientDetailModalState();
}

class _ClientDetailModalState extends State<ClientDetailModal>
    with SingleTickerProviderStateMixin {
  late TabController _scheduleDetailTabController;
  final _storageService = GetIt.I<StorageService>();
  bool isNewPackageAdded = false;

  @override
  void initState() {
    super.initState();

    _scheduleDetailTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[appBar(context), detailContent()]);
  }

  appBar(context) {
    return Material(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(top: 52),
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, isNewPackageAdded),
              child: const Text('Cancel'),
            ),
            Text(
              widget.trainee.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(width: 50),
          ],
        ),
      ),
    );
  }

  detailContent() {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: traineeSessionsForm(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: TabBar(
              controller: _scheduleDetailTabController,
              tabs: [
                Tab(text: 'Schedule History'),
                Tab(text: 'Upcoming schdules'),
              ],
            ),
          ),
          Expanded(child: scheduleDetailsTab()),
        ],
      ),
    );
  }

  traineeName() {
    return Text(
      widget.trainee.name,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
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
      height: 140.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 16.0),
        itemBuilder: (context, index) {
          if (index < packages.length) {
            final package = packages[index];
            return SizedBox(
              width: 100.0,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${package.noOfSessionsAvailable}',
                        style: const TextStyle(
                          fontSize: 55.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Avl.', style: TextStyle(fontSize: 12)),
                      const Spacer(),
                      Text(
                        '\$${package.cost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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

  scheduleDetailsTab() {
    return TabBarView(
      controller: _scheduleDetailTabController,
      children: [
        ClientScheduleHistoryList(clientId: widget.trainee.id),
        ClientUpcomingScheduleList(clientId: widget.trainee.id),
      ],
    );
  }

  int computePendingSesionsForTrainee() {
    return _storageService.getCountOfPendingSessionsForTrainee(widget.trainee);
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
      isNewPackageAdded = true;
      setState(() {});
    }
  }
}
