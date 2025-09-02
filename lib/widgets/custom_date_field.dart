import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isError;

  const CustomDateField({
    Key? key,
    required this.label,
    required this.controller,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            locale: const Locale("en"),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF667EEA),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(picked);
          }
        },
        child: AbsorbPointer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isError
                    ? Colors.redAccent.shade100
                    : const Color(0xFF667EEA).withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isError
                      ? Colors.redAccent.withOpacity(0.1)
                      : const Color(0xFF667EEA).withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: isError
                      ? Colors.redAccent.shade100
                      : const Color(0xFF667EEA),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: Container(

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF667EEA).withOpacity(0.1),
                        const Color(0xFF764BA2).withOpacity(0.1),
                      ],
                    ),

                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFF667EEA),
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
