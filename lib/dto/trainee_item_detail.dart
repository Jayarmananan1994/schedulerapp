import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';

class TraineeItemDetail {
  final Trainee trainee;
  final List<GymPackage> packages;

  TraineeItemDetail({required this.trainee, required this.packages});
}
