import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activities = provider.filteredActivities;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(title: const Text('Daftar Aktivitas')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () => Navigator.pushNamed(context, '/tambah'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: TextField(
                onChanged: (value) =>
                    context.read<ActivityProvider>().setSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Cari aktivitas...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua kategori',
                      selected: provider.categoryFilter == null,
                      onTap: () => context
                          .read<ActivityProvider>()
                          .setCategoryFilter(null),
                    ),
                    ...kCategoriOptions.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _FilterChip(
                          label: c,
                          selected: provider.categoryFilter == c,
                          onTap: () => context
                              .read<ActivityProvider>()
                              .setCategoryFilter(c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua status',
                      selected: provider.statusFilter == null,
                      onTap: () => context
                          .read<ActivityProvider>()
                          .setStatusFilter(null),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: 'Belum selesai',
                        selected: provider.statusFilter == false,
                        onTap: () => context
                            .read<ActivityProvider>()
                            .setStatusFilter(false),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: 'Selesai',
                        selected: provider.statusFilter == true,
                        onTap: () => context
                            .read<ActivityProvider>()
                            .setStatusFilter(true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: activities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aktivitas tidak ditemukan.',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      itemCount: activities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final a = activities[index];
                        return ActivityCard(
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: kPrimaryColor,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
        fontSize: 12,
      ),
      backgroundColor: Colors.white,
    );
  }
}
