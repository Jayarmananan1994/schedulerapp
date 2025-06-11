import 'package:schedulerapp/entity/gym_package.dart';
import 'package:schedulerapp/entity/trainee.dart';

class ExpiringClientSession {
  final Trainee trainee;
  final GymPackage gympackage;

  ExpiringClientSession(this.trainee, this.gympackage);
}
