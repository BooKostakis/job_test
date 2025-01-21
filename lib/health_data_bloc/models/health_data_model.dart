class HealthDataModel {
  final List<HealthDynamic> dynamics;
  final List<Alert> alerts;

  HealthDataModel({required this.dynamics, required this.alerts});

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      dynamics: List<HealthDynamic>.from(json['dynamics'].map((x) => HealthDynamic.fromJson(x))),
      alerts: List<Alert>.from(json['alerts'].map((x) => Alert.fromJson(x))),
    );
  }
}

class HealthDynamic {
  final String date;
  final String lab;
  final double value;

  HealthDynamic({required this.date, required this.lab, required this.value});

  factory HealthDynamic.fromJson(Map<String, dynamic> json) {
    return HealthDynamic(
      date: json['date'],
      lab: json['lab'],
      value: json['value'].toDouble(),
    );
  }
}

class Alert {
  final String message;
  final bool resubmitLink;

  Alert({required this.message, required this.resubmitLink});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      message: json['message'],
      resubmitLink: json['resubmitLink'],
    );
  }
}
