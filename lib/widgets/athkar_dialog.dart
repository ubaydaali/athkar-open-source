import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/zekr_model.dart';

class AthkarDialog extends StatefulWidget {
  final ZekrCategory category;

  const AthkarDialog({super.key, required this.category});

  @override
  State<AthkarDialog> createState() => _AthkarDialogState();
}

class _AthkarDialogState extends State<AthkarDialog> {
  late List<int> _currentCounts;
  late Color _themeColor;

  @override
  void initState() {
    super.initState();
    // Copy the original counts so we can decrement them locally
    _currentCounts = widget.category.items.map((item) => item.count).toList();
    _themeColor = Color(int.parse(widget.category.color));
  }

  void _decrementCount(int index) {
    if (_currentCounts[index] > 0) {
      setState(() {
        _currentCounts[index]--;
      });
      // Add a light haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  void _resetCounts() {
    setState(() {
      _currentCounts = widget.category.items.map((item) => item.count).toList();
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
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
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _themeColor,
                      _themeColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconData(widget.category.icon),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.title,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'اضغط على الكارت لتكرار الذكر',
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
                    // Reset Button
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      tooltip: 'إعادة تعيين العدادات',
                      onPressed: _resetCounts,
                    ),
                    // Close Button
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Supplications List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.category.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.category.items[index];
                    final currentCount = _currentCounts[index];
                    final isCompleted = currentCount == 0;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? Colors.green.shade50 
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCompleted 
                              ? Colors.green.shade300 
                              : Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _decrementCount(index),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Text content of supplication
                                Text(
                                  item.text,
                                  style: GoogleFonts.amiri(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
                                      color: isCompleted 
                                          ? Colors.green.shade900 
                                          : Colors.black87,
                                    ),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 12),
                                // Footer: Reward and Counter
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Reward details
                                    Expanded(
                                      child: item.reward.isNotEmpty
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: isCompleted 
                                                    ? Colors.green.shade100.withValues(alpha: 0.5)
                                                    : _themeColor.withValues(alpha: 0.05),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item.reward,
                                                style: GoogleFonts.tajawal(
                                                  textStyle: TextStyle(
                                                    fontSize: 11,
                                                    color: isCompleted 
                                                        ? Colors.green.shade800 
                                                        : Colors.grey.shade600,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    const SizedBox(width: 12),
                                    // Interactive counter
                                    AnimatedScale(
                                      scale: isCompleted ? 0.95 : 1.0,
                                      duration: const Duration(milliseconds: 150),
                                      child: Container(
                                        height: 52,
                                        width: 52,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: isCompleted
                                                ? [Colors.green, Colors.green.shade700]
                                                : [_themeColor, _themeColor.withValues(alpha: 0.8)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (isCompleted ? Colors.green : _themeColor).withValues(alpha: 0.3),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: isCompleted
                                              ? const Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                )
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '$currentCount',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'تكرار',
                                                      style: TextStyle(
                                                        color: Colors.white.withValues(alpha: 0.7),
                                                        fontSize: 8,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'moon':
        return Icons.nights_stay_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      default:
        return Icons.bookmark_rounded;
    }
  }
}
