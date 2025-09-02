class ShipmentTrackingModel {
  final List<TrackingRoute> routes;
  final List<TrackingLog> logs;

  ShipmentTrackingModel({
    required this.routes,
    required this.logs,
  });

  factory ShipmentTrackingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ShipmentTrackingModel(
      routes: (data['routes'] as List? ?? [])
          .map((e) => TrackingRoute.fromJson(e))
          .toList(),
      logs: (data['logs'] as List? ?? [])
          .map((e) => TrackingLog.fromJson(e))
          .toList(),
    );
  }
}

class TrackingRoute {
  final int id;
  final int shipmentId;
  final String trackingLink;

  TrackingRoute({
    required this.id,
    required this.shipmentId,
    required this.trackingLink,
  });

  factory TrackingRoute.fromJson(Map<String, dynamic> json) {
    return TrackingRoute(
      id: json['id'] ?? 0,
      shipmentId: json['shipment_id'] ?? 0,
      trackingLink: json['tracking_link'] ?? '',
    );
  }
}

class TrackingLog {
  final String? status;
  final String? date;

  TrackingLog({this.status, this.date});

  factory TrackingLog.fromJson(Map<String, dynamic> json) {
    return TrackingLog(
      status: json['status'],
      date: json['date'],
    );
  }
}
