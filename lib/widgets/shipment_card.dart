import 'package:flutter/material.dart';
import '../model/ShipmentModel.dart';

class ShipmentCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback onConfirm;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onInvoice;
  final VoidCallback? onTracing;
  final VoidCallback? onContract;
  final bool showStatus;

  const ShipmentCard({
    super.key,
    required this.shipment,
    required this.onConfirm,
    required this.onEdit,
    required this.onDelete,
    required this.onInvoice,
    required this.onTracing,
    required this.showStatus,
    required this.onContract,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Color(0xFF667EEA),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Color(0xFF764BF2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 4,
              children: [
                if (shipment.serviceType != null)
                  Chip(
                    label: Text(shipment.serviceType!.toUpperCase()),
                    backgroundColor: Colors.purple.shade50,
                    labelStyle: TextStyle(color: Color(0xFF764BA2), fontWeight: FontWeight.bold),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (shipment.shippingMethod != null)
                  Chip(
                    label: Text(shipment.shippingMethod!.toUpperCase()),
                    backgroundColor: Colors.lightBlue.shade50,
                    labelStyle: TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.bold),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (showStatus && shipment.status != null)
                  Chip(
                    label: Text(shipment.status!.toUpperCase()),
                    backgroundColor: Colors.orange.shade50,
                    labelStyle: TextStyle(
                      color: Colors.orange.shade200,
                      fontWeight: FontWeight.bold,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (onContract != null)
                  ActionChip(
                    label: const Text("العقد"),
                    onPressed: onContract!,
                    backgroundColor: Colors.brown.shade50,
                    labelStyle: const TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 15),
                const SizedBox(width: 6),
                Text(
                  "Dep. ${shipment.shippingDate ?? "--"}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.flight_takeoff, size: 15),
                const SizedBox(width: 1),
                Text(
                  "From: ${shipment.originCountry ?? '--'}",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.flight_land, size: 15),
                const SizedBox(width: 1),
                Text(
                  "To : ${shipment.destinationCountry ?? '--'}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onInvoice,
                  icon: const Icon(Icons.receipt_long, color: Colors.blue),
                  tooltip: "فاتورة الشحنة",
                ),
                if (!(shipment.isConfirmed ?? false)) ...[
                  IconButton(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    tooltip: "تأكيد الشحنة",
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    tooltip: "تعديل الشحنة",
                  ),
                ],
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.purple),
                  tooltip: "حذف الشحنة",
                ),
                if (onTracing != null)
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.teal),
                    onPressed: onTracing,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
