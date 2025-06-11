import 'package:schedulerapp/entity/gym_package.dart';
import 'package:schedulerapp/entity/trainee.dart';

class TraineeItemDetail {
  final Trainee trainee;
  final List<GymPackage> packages;

  TraineeItemDetail({required this.trainee, required this.packages});
}
