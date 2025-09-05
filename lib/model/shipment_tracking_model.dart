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
  final String trackingNumber;

  TrackingRoute({
    required this.id,
    required this.shipmentId,
    required this.trackingLink,
    required this.trackingNumber,
  });

  factory TrackingRoute.fromJson(Map<String, dynamic> json) {
    return TrackingRoute(
      id: json['id'] ?? 0,
      shipmentId: json['shipment_id'] ?? 0,
      trackingLink: json['tracking_link'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
    );
  }
}

class TrackingLog {
  final int id;
  final int shipmentId;
  final String location;

  TrackingLog({
    required this.id,
    required this.shipmentId,
    required this.location,
  });

  factory TrackingLog.fromJson(Map<String, dynamic> json) {
    return TrackingLog(
      id: json['id'] ?? 0,
      shipmentId: json['shipment_id'] ?? 0,
      location: json['location'] ?? 'غير معروف',
    );
  }
}


