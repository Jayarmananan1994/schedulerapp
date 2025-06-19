import 'package:schedulerapp/data/models/gym_package.dart';
import 'package:schedulerapp/data/models/trainee.dart';

class ExpiringClientSession {
  final Trainee trainee;
  final GymPackage gympackage;

  ExpiringClientSession(this.trainee, this.gympackage);
}
