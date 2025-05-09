import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedulerapp/component/add_client_modal.dart';
import 'package:schedulerapp/model/trainee.dart';
import 'package:schedulerapp/service/storage_service.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
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
            final staffList = snapshot.data!;
            return ListView.builder(
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final staff = staffList[index];
                return ListTile(
                  title: Text(staff.name),
                  subtitle: Text('\$ ${staff.feePerSession.toString()}'),
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
}
