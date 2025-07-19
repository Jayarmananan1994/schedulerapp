import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/dto/gym_stats.dart';
import 'package:schedulerapp/page/gym_management/trainee_list_widget.dart';
import 'package:schedulerapp/page/gym_management/trainer_list_widget.dart';
import 'package:schedulerapp/service/storage_service.dart';

class GymManagementScreen extends StatefulWidget {
  final Function? onTrainerUpdate;
  final Function? onTraineeUpdate;
  const GymManagementScreen({
    super.key,
    this.onTrainerUpdate,
    this.onTraineeUpdate,
  });

  @override
  State<GymManagementScreen> createState() => _GymManagementScreenState();
}

class _GymManagementScreenState extends State<GymManagementScreen> {
  final StorageService _storageService = GetIt.I<StorageService>();

  late GymStats statsDetail;

  @override
  void initState() {
    statsDetail = _storageService.getGymStats();
    // Provider.of<TrainerProvider>(context, listen: false).getTrainerList();
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
                    TrainerListWidget(
                      onTrainerAdded: (value) {
                        setState(() {
                          statsDetail = _storageService.getGymStats();
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TraineeListWidget(
                      onTraineeAdded: () {
                        setState(() {
                          statsDetail = _storageService.getGymStats();
                        });
                        widget.onTraineeUpdate!(true);
                      },
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
}
