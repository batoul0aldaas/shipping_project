import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final String? hintText;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.prefixIcon,
    this.onTap,
    this.hintText,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: hasError
                    ? Colors.redAccent
                    : const Color(0xFF667EEA).withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: hasError
                      ? Colors.redAccent.withOpacity(0.15)
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
              style: TextStyle(
                color: hasError ? Colors.redAccent : Colors.black87,
              ),
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
                    color: hasError
                        ? Colors.redAccent
                        : const Color(0xFF667EEA),
                    size: 20,
                  ),
                )
                    : null,
                labelStyle: TextStyle(
                  color: hasError ? Colors.redAccent : const Color(0xFF667EEA),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: TextStyle(
                  color: hasError
                      ? Colors.redAccent.withOpacity(0.6)
                      : const Color(0xFF64748B).withOpacity(0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: prefixIcon != null ? 8 : 20,
                  vertical: 18,
                ),
              ),
            ),
          ),


          if (hasError) ...[
            const SizedBox(height: 5),
            Text(
              errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
