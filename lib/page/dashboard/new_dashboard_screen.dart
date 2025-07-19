import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/page/dashboard/dashboard_post_setup_widget.dart';
import 'package:schedulerapp/page/dashboard/dashboard_pre_setup_widget.dart';
import 'package:schedulerapp/provider/schedule_provider.dart';
import 'package:schedulerapp/provider/trainee_provider.dart';
import 'package:schedulerapp/provider/trainer_provider.dart';

class NewDashboardScreen extends StatelessWidget {
  const NewDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isSetupComplete = computeSetupComplete(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Dashboard',
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
              child: Selector3<
                TrainerProvider,
                TraineeProvider,
                ScheduleProvider,
                bool
              >(
                builder: (context, isSetupComplete, child) {
                  return isSetupComplete
                      ? DashboardPostSetupWidget()
                      : DashboardPreSetupWidget();
                },
                selector: (
                  context,
                  trainerProvider,
                  traineeProvider,
                  scheduleProvider,
                ) {
                  return computeSetupComplete(
                    trainerProvider.trainerList.length,
                    traineeProvider.trainees.length,
                    scheduleProvider.scheduleDto.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool computeSetupComplete(
    int trainerListSize,
    int traineeListSize,
    int scheduleListSize,
  ) {
    return trainerListSize > 0 && traineeListSize > 0 && scheduleListSize > 0;
  }
}
