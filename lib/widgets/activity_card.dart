import 'package:flutter/material.dart';
import '../models/activity.dart';

const kPrimaryColor = Color(0xFF006633);
const kBackgroundColor = Color(0xFFEEF7EF);

/// Komponen kartu yang dipakai ulang di layar Beranda, Daftar Aktivitas,
/// dan Favorit.
class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                activity.isDone ? Icons.check_circle : Icons.schedule,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: activity.isDone
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      activity.isDone ? 'Selesai' : 'Belum selesai',
                      style: TextStyle(
                        fontSize: 11,
                        color: activity.isDone
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                activity.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: activity.isFavorite ? Colors.redAccent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
