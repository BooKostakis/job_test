part of 'health_data_bloc.dart';

abstract class HealthDataState extends Equatable {
  const HealthDataState();

  @override
  List<Object> get props => [];
}

class HealthDataInitial extends HealthDataState {}

class HealthDataLoading extends HealthDataState {}

class HealthDataLoaded extends HealthDataState {
  final HealthDataModel healthData;

  const HealthDataLoaded(this.healthData);

  @override
  List<Object> get props => [healthData];
}

class HealthDataError extends HealthDataState {
  final String message;

  const HealthDataError(this.message);

  @override
  List<Object> get props => [message];
}
