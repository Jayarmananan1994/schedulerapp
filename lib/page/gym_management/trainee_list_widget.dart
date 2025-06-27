import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';
import 'package:schedulerapp/dto/trainee_item_detail.dart';
import 'package:schedulerapp/modal/add_client/add_client_modal.dart';
import 'package:schedulerapp/service/storage_service.dart';

class TraineeListWidget extends StatefulWidget {
  final Function onTraineeAdded;
  const TraineeListWidget({super.key, required this.onTraineeAdded});

  @override
  State<TraineeListWidget> createState() => _TraineeListWidgetState();
}

class _TraineeListWidgetState extends State<TraineeListWidget> {
  final StorageService _storageService = GetIt.I<StorageService>();
  late Future<List<TraineeItemDetail>> _traineeListFuture;

  @override
  void initState() {
    _traineeListFuture = _storageService.getTraineeDetailList();
    print('Trainee List Future initialized');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trainees',
                style: GoogleFonts.inter(
                  color: colorblack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 140,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _showAddTraineePage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Add Trainee',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _trainerList(),
        ],
      ),
    );
  }

  _trainerList() {
    return FutureBuilder<List<TraineeItemDetail>>(
      future: _traineeListFuture,
      builder: (context, snapshot) {
        print('Connection state: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 160,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.data!.isEmpty) {
          return SizedBox(
            height: 160,
            child: Center(
              child: Text(
                'No trainees available.',
                style: GoogleFonts.inter(fontSize: 16, color: colorGreyTwo),
              ),
            ),
          );
        } else {
          var list = snapshot.data!;
          return Column(
            children:
                list.map((entry) {
                  Trainee staff = entry.trainee;
                  List<GymPackage> packages = entry.packages;
                  return Container(
                    width: double.infinity,
                    height: 130,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorShadowGrey,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(staff.imageUrl!),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  staff.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: colorblack,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Trainee',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: colorGreyTwo,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: colorGreyTwo,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        _gympackageChips(packages),
                      ],
                    ),
                  );
                }).toList(),
          );
        }
      },
    );
  }

  _showAddTraineePage(BuildContext context) async {
    bool isCreated = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddClientModal(),
      ),
    );

    if (isCreated) {
      setState(() {
        _traineeListFuture = _storageService.getTraineeDetailList();
      });
      widget.onTraineeAdded();
    }
  }

  _gympackageChips(List<GymPackage> packages) {
    var items = packages.length > 3 ? packages.sublist(0, 3) : packages;
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorBlueTwo.withOpacity(0.1),
            ),
            child: Text(
              '${items[index].name} - ${items[index].noOfSessionsAvailable} sessions',
              style: GoogleFonts.inter(fontSize: 14, color: colorBlueTwo),
            ),
          );
        },
      ),
    );
  }
}
