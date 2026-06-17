import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/worship_model.dart';

class WorshipDialog extends StatelessWidget {
  final Worship worship;

  const WorshipDialog({super.key, required this.worship});

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(int.parse(worship.color));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 10,
        backgroundColor: Colors.grey[50] ?? Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeColor,
                      themeColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getIconData(worship.icon),
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worship.title,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'شرح العبادة وفضلها وتفاصيلها',
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Close Button
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content Body
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Description / Explanation
                      _buildSectionHeader('شرح العبادة', Icons.info_outline_rounded, themeColor),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          worship.description,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 2: Importance & Virtue
                      _buildSectionHeader('أهميتها وفضلها في الإسلام', Icons.star_border_rounded, themeColor),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              themeColor.withValues(alpha: 0.08),
                              themeColor.withValues(alpha: 0.02),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          worship.importance,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                              color: themeColor.withValues(alpha: 0.95),
                            ),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 3: Details list
                      _buildSectionHeader('تفاصيل وأحكام هامة', Icons.menu_book_rounded, themeColor),
                      const SizedBox(height: 10),
                      ...worship.details.asMap().entries.map((entry) {
                        int index = entry.key;
                        String text = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.01),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Number Badge
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Detail Text
                              Expanded(
                                child: Text(
                                  text,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.tajawal(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'mosque':
        return Icons.mosque_rounded;
      case 'fasting':
        return Icons.wb_twilight_rounded; // Represents crescent moon / dusk
      case 'zakat':
        return Icons.volunteer_activism_rounded; // Represents charity
      case 'hajj':
        return Icons.explore_rounded; // Represents pilgrimage / travel
      default:
        return Icons.bookmark_rounded;
    }
  }
}
