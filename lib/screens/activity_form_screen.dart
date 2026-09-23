import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';

/// Layar ini dipakai untuk dua mode sekaligus: Tambah (activityId null)
/// dan Edit (activityId terisi) -- ini yang memenuhi syarat "layar
/// Tambah/Edit" sebagai satu komponen form yang dipakai ulang.
class ActivityFormScreen extends StatefulWidget {
  final String? activityId;

  const ActivityFormScreen({super.key, this.activityId});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _category = kCategoriOptions.first;
  DateTime _deadline = DateTime.now().add(const Duration(days: 1));

  bool get isEditMode => widget.activityId != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      // Isi form dengan data lama supaya "Batal" tidak mengubah apa pun
      // -- perubahan hanya tersimpan kalau tombol Simpan ditekan.
      final activity = context.read<ActivityProvider>().getById(
        widget.activityId!,
      );
      if (activity != null) {
        _titleController.text = activity.title;
        _descController.text = activity.description;
        _category = activity.category;
        _deadline = activity.deadline;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Aktivitas' : 'Tambah Aktivitas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Judul aktivitas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Contoh: Mengerjakan tugas'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Judul minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Kategori',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: _inputDecoration(''),
                  items: kCategoriOptions
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: _inputDecoration('Detail aktivitas'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Deadline',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                    );
                    if (picked != null) setState(() => _deadline = picked);
                  },
                  child: InputDecorator(
                    decoration: _inputDecoration(''),
                    child: Text(
                      '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        // Batal: langsung kembali tanpa memanggil
                        // provider sama sekali, jadi data lama tetap utuh.
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(isEditMode ? 'Simpan' : 'Tambah'),
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
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ActivityProvider>();
    if (isEditMode) {
      provider.updateActivity(
        widget.activityId!,
        title: _titleController.text.trim(),
        category: _category,
        description: _descController.text.trim(),
        deadline: _deadline,
      );
    } else {
      provider.addActivity(
        title: _titleController.text.trim(),
        category: _category,
        description: _descController.text.trim(),
        deadline: _deadline,
      );
    }
    Navigator.pop(context);
  }
}
