import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_test/common/helpers/data_row.dart';
import 'package:job_test/common/theme/app_colors.dart';
import 'package:job_test/common/theme/theme.dart';
import 'package:job_test/common/widgets/line_chart_widget.dart';
import 'package:job_test/health_data_bloc/health_data_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(const YourHealthApp());
}

class YourHealthApp extends StatelessWidget {
  const YourHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HealthDataBloc(),
      child: const MaterialApp(
        home: YourHealthScreen(),
      ),
    );
  }
}

class YourHealthScreen extends StatefulWidget {
  const YourHealthScreen({super.key});

  @override
  State<YourHealthScreen> createState() => _YourHealthScreenState();
}

class _YourHealthScreenState extends State<YourHealthScreen> {
  final String url = 'http://158.160.30.46:8080/health_mock';
  @override
  void initState() {
    super.initState();
    context.read<HealthDataBloc>().add(HealthDataFetch(url));
  }

  Future<void> _refreshData() async {
    context.read<HealthDataBloc>().add(HealthDataFetch(url));
    await Future.delayed(const Duration(milliseconds: 500)); //задержка для иминации загрузки
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = appTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxHeight = constraints.maxHeight;
            final double maxWidth = constraints.maxWidth;
            final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final double adjustedHeight = keyboardHeight > 0 ? maxHeight - keyboardHeight : maxHeight;
            return SizedBox(
              height: adjustedHeight,
              width: maxWidth,
              child: RefreshIndicator(
                onRefresh: _refreshData, // Функция для pull-to-refresh
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        softWrap: true,
                        'Dynamics',
                        style: theme.textTheme.headlineLarge,
                      ),
                      Text(
                        softWrap: true,
                        'All Period',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<HealthDataBloc, HealthDataState>(builder: (context, state) {
                        if (state is HealthDataLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is HealthDataError) {
                          return Center(child: Text('Ошибка: ${state.message}'));
                        } else if (state is HealthDataLoaded) {
                          return Column(children: [
                            Center(
                              child: SizedBox(
                                width: maxWidth,
                                child: const LineChartWidget(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (state.healthData.alerts.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.applightGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(state.healthData.alerts[0].message,
                                            style: Theme.of(context).textTheme.bodyMedium),
                                      ),
                                      if (state.healthData.alerts[0].resubmitLink == true)
                                        TextButton(
                                          onPressed: () {
                                            print("Resubmit requested");
                                          },
                                          child: Text(
                                            'Resubmit the markers',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: maxWidth,
                              child: DataTable(
                                columnSpacing: 10,
                                horizontalMargin: 16,
                                columns: [
                                  DataColumn(
                                    label: Text('Дата', style: theme.textTheme.bodySmall),
                                    headingRowAlignment: MainAxisAlignment.start,
                                  ),
                                  DataColumn(
                                    label: Text('', style: theme.textTheme.bodySmall),
                                    headingRowAlignment: MainAxisAlignment.start,
                                  ),
                                  DataColumn(
                                    label: Text('МЕ/мл', style: theme.textTheme.bodySmall),
                                    headingRowAlignment: MainAxisAlignment.end,
                                  ),
                                ],
                                rows: state.healthData.dynamics
                                    .map((dynamicData) => buildDataRow(dynamicData, theme))
                                    .toList(),
                              ),
                            ),
                          ]);
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
