import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedulerapp/component/gogym_avatar.dart';
import 'package:schedulerapp/constant.dart';
import 'package:schedulerapp/data/models/trainer.dart';
import 'package:schedulerapp/domain/service/schedule_service.dart';
import 'package:schedulerapp/dto/schedule_dto.dart';
import 'package:schedulerapp/page/trainer_schedule_history/schdeule_card.dart';

class TrainerScheduleHistoryPage extends StatefulWidget {
  final Trainer trainer;
  const TrainerScheduleHistoryPage({super.key, required this.trainer});

  @override
  State<TrainerScheduleHistoryPage> createState() =>
      _TrainerScheduleHistoryPageState();
}

class _TrainerScheduleHistoryPageState
    extends State<TrainerScheduleHistoryPage> {
  String selectedFilter = 'Today';
  final ScheduleService _scheduleService = GetIt.I<ScheduleService>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(trainerScheduleProvider.notifier)
    //       .fetchSchedules(widget.trainer.id, selectedFilter);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Schedule History',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
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
              child: SingleChildScrollView(child: contentIos()),
            ),
          ],
        ),
      ),
    );
  }

  contentIos() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _trainerInfo(),
          SizedBox(height: 16),
          _summary(),
          SizedBox(height: 16),
          _filterOptions(),
          SizedBox(height: 16),
          _scheduleTitle(),
          SizedBox(height: 16),
          _schduleList(),
        ],
      ),
    );
  }

  Text _scheduleTitle() {
    String title = '';
    switch (selectedFilter) {
      case 'Today':
        title = "Today's Schedule";
        break;
      case 'Upcoming':
        title = 'Upcoming Schedule';
        break;
      case 'Completed':
        title = 'Completed Schedule';
        break;
      case 'All':
        title = 'All Schedules';
        break;
      default:
        title = 'Schedule History';
    }

    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorblack,
      ),
    );
  }

  _trainerInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          avatarWidget(),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.trainer.name,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colorblack,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.trainer.role,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorGreyTwo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  avatarWidget() {
    return SizedBox(
      width: 64,
      height: 64,
      child: GoGymAvatar(
        imageUrl: widget.trainer.imageUrl,
        text: widget.trainer.name[0].toUpperCase(),
      ),
    );
  }

  _summary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        info('156', 'Sessions completed'),
        info('20', 'Active clients'),
      ],
    );
  }

  _filterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              filterChip('Today'),
              SizedBox(width: 8),
              filterChip('Upcoming'),
              SizedBox(width: 8),
              filterChip('Completed'),
              SizedBox(width: 8),
              filterChip('All'),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(), // Placeholder for future schedule list
      ],
    );
  }

  Widget filterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
        //ref.fetchSchedules(widget.trainer.id, label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorBlue : colorgreyShadeThree,
          border: Border.all(color: isSelected ? colorBlue : colorGreyTwo),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : colorGreyTwo,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  info(title, subtitle) {
    return Container(
      height: 84,
      width: 170,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorShadowGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: colorblack,
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

  Widget _schduleList() {
    return FutureBuilder<List<ScheduleDto>>(
      future: _scheduleService.getSchedulesByClientId(widget.trainer.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Oops! We encountered an error while fetching schedules.',
              style: GoogleFonts.inter(color: colorGreyTwo),
            ),
          );
        }

        final schedules = snapshot.data;
        if (schedules == null || schedules.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: schedules.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return ScheduleCard(
              clientName: schedule.trainee.name,
              time: '${schedule.startTime} - ${schedule.endTime}',
              status: '',
              type: '', //schedule.packageId,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final messages = {
      'Today': "No sessions scheduled for today!\nTime for a coffee break! ☕",
      'Upcoming':
          "Your schedule is clear ahead!\nPerfect time to plan new sessions! 📅",
      'Completed':
          "No completed sessions yet!\nThe journey of a thousand miles begins with a single step! 🚶",
      'All': "No sessions found!\nLet's get this party started! 🎉",
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.calendar, size: 48, color: colorGreyTwo),
            SizedBox(height: 16),
            Text(
              messages[selectedFilter] ?? messages['All']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorGreyTwo,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
