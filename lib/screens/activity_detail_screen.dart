import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import 'activity_form_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String id;
  const ActivityDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activity = provider.getById(id);

    if (activity == null) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(title: const Text('Detail Aktivitas')),
        body: Center(
          child: Text(
            'Aktivitas tidak ditemukan (mungkin sudah dihapus).',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        actions: [
          IconButton(
            icon: Icon(
              activity.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: activity.isFavorite ? Colors.redAccent : null,
            ),
            onPressed: () =>
                context.read<ActivityProvider>().toggleFavorite(activity.id),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(label: Text(activity.category)),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            activity.isDone ? 'Selesai' : 'Belum selesai',
                          ),
                          backgroundColor: activity.isDone
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(activity.description),
                    const SizedBox(height: 16),
                    const Text(
                      'Deadline',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activity.deadline.day}/${activity.deadline.month}/${activity.deadline.year}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context
                      .read<ActivityProvider>()
                      .toggleDone(activity.id),
                  icon: Icon(activity.isDone ? Icons.undo : Icons.check),
                  label: Text(
                    activity.isDone
                        ? 'Tandai belum selesai'
                        : 'Tandai selesai',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ActivityFormScreen(activityId: activity.id),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () => _confirmDelete(context, activity.id),
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus aktivitas?'),
        content: const Text(
          'Aktivitas yang dihapus tidak dapat dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<ActivityProvider>().deleteActivity(id);
              Navigator.pop(dialogContext); // tutup dialog
              Navigator.pop(context); // kembali ke daftar
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
