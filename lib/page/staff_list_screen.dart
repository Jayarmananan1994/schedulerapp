import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/component/add_staff_modal.dart';
import 'package:schedulerapp/component/staff_detail_modal.dart';
import 'package:schedulerapp/model/staff.dart';
import 'package:schedulerapp/service/storage_service.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final StorageService _storageService = GetIt.instance<StorageService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trainers',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Staff>>(
        future: _storageService.getStaffList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No staff available.'));
          } else {
            final staffList = snapshot.data!;
            return ListView.builder(
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final staff = staffList[index];
                return ListTile(
                  onTap:
                      () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return StaffDetailModal(staff: staff);
                        },
                      ),
                  title: Text(staff.name),
                  subtitle: Text('\$ ${staff.payRate.toString()}'),
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
    var isStaffAdded = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddStaffModal(),
    );
    if (isStaffAdded != null && isStaffAdded) {
      setState(() {});
    }
  }
}
