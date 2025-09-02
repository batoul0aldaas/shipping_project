import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isError;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final String? hintText;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isError = false,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.prefixIcon,
    this.onTap,
    this.hintText,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
            color: isError
                ? Colors.redAccent.shade100
                : const Color(0xFF667EEA).withOpacity(0.1),
            width: 1,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            prefixIcon: prefixIcon != null
                ? Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
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
              child: Icon(
                prefixIcon,
                color: const Color(0xFF667EEA),
                size: 20,
              ),
            )
                : null,
            labelStyle: TextStyle(
              color: isError
                  ? Colors.redAccent.shade100
                  : const Color(0xFF667EEA),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(
              color: const Color(0xFF64748B).withOpacity(0.6),
              fontSize: 14,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: prefixIcon != null ? 8 : 20,
              vertical: 18,
            ),          ),
        ),
      ),
    );
  }
}
