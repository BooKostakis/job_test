part of 'health_data_bloc.dart';

abstract class HealthDataEvent extends Equatable {
  const HealthDataEvent();

  @override
  List<Object> get props => [];
}

class HealthDataFetch extends HealthDataEvent {
  final String url;

  const HealthDataFetch(this.url);

  @override
  List<Object> get props => [url];
}
