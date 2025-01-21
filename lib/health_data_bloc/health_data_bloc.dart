import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_test/common/helpers/fetch_data_json.dart';
import 'package:job_test/health_data_bloc/models/health_data_model.dart';

part 'health_data_event.dart';
part 'health_data_state.dart';

class HealthDataBloc extends Bloc<HealthDataEvent, HealthDataState> {
  HealthDataBloc() : super(HealthDataInitial()) {
    on<HealthDataFetch>((event, emit) async {
      emit(HealthDataLoading());
      try {
        final json = await fetchDataFromUrl(event.url);
        final healthData = HealthDataModel.fromJson(json);
        emit(HealthDataLoaded(healthData));
      } catch (e) {
        emit(HealthDataError('Ошибка: $e'));
      }
    });
  }
}
