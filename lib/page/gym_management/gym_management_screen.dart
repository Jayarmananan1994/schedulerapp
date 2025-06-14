import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/dto/gym_stats.dart';
import 'package:schedulerapp/entity/staff.dart';
import 'package:schedulerapp/modal/add_staff_modal.dart';
import 'package:schedulerapp/page/gym_management/trainee_list_widget.dart';
import 'package:schedulerapp/service/storage_service.dart';

class GymManagementScreen extends StatefulWidget {
  const GymManagementScreen({super.key});

  @override
  State<GymManagementScreen> createState() => _GymManagementScreenState();
}

class _GymManagementScreenState extends State<GymManagementScreen> {
  final StorageService _storageService = GetIt.I<StorageService>();

  late GymStats statsDetail;

  @override
  void initState() {
    statsDetail = _storageService.getGymStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Gym Management',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: colorblack,
            ),
          ),
        ),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stats(),
                    SizedBox(height: 16),
                    staffList(context),
                    SizedBox(height: 16),
                    TraineeListWidget(
                      onTraineeAdded:
                          () => setState(() {
                            statsDetail = _storageService.getGymStats();
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  title() {
    return Text(
      'Gym Management',
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: colorblack,
      ),
    );
  }

  stats() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(
            Icons.groups,
            'Staff',
            statsDetail.totalTrainers.toString(),
            'Active Members',
          ),
          _statItem(
            Icons.groups_2,
            'Trainees',
            statsDetail.totalActiveClients.toString(),
            'Active Members',
          ),
        ],
      ),
    );
  }

  _statItem(icon, title, content, subtitle) {
    return Container(
      width: 170,
      height: 140,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colorShadowGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorBlue),
              SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.inter(color: colorGreyTwo, fontSize: 14),
              ),
            ],
          ),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 14, color: colorGreyTwo),
          ),
        ],
      ),
    );
  }

  staffList(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Staff Members',
                style: GoogleFonts.inter(
                  color: colorblack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded edges,
                    ),
                  ),
                  onPressed: () => _showAddStaffPage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Add Staff',
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
          _staffList(),
        ],
      ),
    );
  }

  _showAddStaffPage(BuildContext context) async {
    bool isCreated = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddStaffModal(),
      ),
    );
    if (isCreated) {
      setState(() {
        statsDetail = _storageService.getGymStats();
      });
    }
  }

  _staffList() {
    return FutureBuilder<List<Staff>>(
      future: _storageService.getStaffList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 180,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 160,
            child: Center(
              child: Text(
                'No staff available.',
                style: GoogleFonts.inter(fontSize: 16, color: colorGreyTwo),
              ),
            ),
          );
        } else {
          var list = snapshot.data!;
          return SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var staff = list[index];
                return Container(
                  width: 220,
                  height: 160,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorShadowGrey,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(staff.imageUrl!),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                icon: Icon(Icons.close, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        staff.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorblack,
                        ),
                      ),
                      Text(
                        'Head Trainer',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: colorGreyTwo,
                        ),
                      ),
                      Text(
                        '\$${staff.payRate}/h',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: colorGreyTwo,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemCount: list.length,
            ),
          );
        }
      },
    );
  }
}
