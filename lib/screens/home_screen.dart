import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final recent = provider.allActivities.take(3).toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(title: const Text('Study Planner')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo, Olivia!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Berikut ringkasan aktivitas belajarmu.'),
              const SizedBox(height: 20),

              Row(
                children: [
                  _StatCard(
                    label: 'Total',
                    value: provider.totalActivities.toString(),
                    icon: Icons.list_alt,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Selesai',
                    value: provider.doneCount.toString(),
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Favorit',
                    value: provider.favoriteCount.toString(),
                    icon: Icons.favorite,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/daftar'),
                      icon: const Icon(Icons.list),
                      label: const Text('Daftar Aktivitas'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/favorit'),
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Favorit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/profil'),
                  icon: const Icon(Icons.person),
                  label: const Text('Lihat Profil'),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Aktivitas terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (recent.isEmpty)
                const _EmptyState(message: 'Belum ada aktivitas.')
              else
                ...recent.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ActivityCard(
                      activity: a,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActivityDetailScreen(id: a.id),
                        ),
                      ),
                      onFavoriteTap: () => context
                          .read<ActivityProvider>()
                          .toggleFavorite(a.id),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: kPrimaryColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
