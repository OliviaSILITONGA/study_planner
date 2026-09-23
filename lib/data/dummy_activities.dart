import '../models/activity.dart';

List<Activity> generateDummyActivities() {
  final now = DateTime.now();
  return [
    Activity(
      id: 'A001',
      title: 'Mengerjakan Tugas Pemrograman Mobile',
      category: 'Tugas',
      description: 'Membuat aplikasi Study Planner untuk UTS.',
      deadline: now.add(const Duration(days: 2)),
      isDone: false,
      isFavorite: true,
    ),
    Activity(
      id: 'A002',
      title: 'Belajar Basis Data',
      category: 'Kuliah',
      description: 'Review materi normalisasi tabel sebelum kuis.',
      deadline: now.add(const Duration(days: 1)),
      isDone: false,
    ),
    Activity(
      id: 'A003',
      title: 'Rapat Himpunan Mahasiswa',
      category: 'Organisasi',
      description: 'Rapat evaluasi program kerja semester ini.',
      deadline: now.add(const Duration(days: 3)),
      isDone: false,
    ),
    Activity(
      id: 'A004',
      title: 'Olahraga Pagi',
      category: 'Pribadi',
      description: 'Jogging di sekitar kampus selama 30 menit.',
      deadline: now.subtract(const Duration(days: 1)),
      isDone: true,
    ),
    Activity(
      id: 'A005',
      title: 'Mengerjakan Laporan Praktikum Jaringan',
      category: 'Tugas',
      description: 'Menyusun laporan hasil praktikum minggu ke-5.',
      deadline: now.add(const Duration(days: 4)),
      isDone: false,
    ),
    Activity(
      id: 'A006',
      title: 'Kuliah Keamanan Data',
      category: 'Kuliah',
      description: 'Menghadiri kuliah tatap muka pukul 08.00.',
      deadline: now.add(const Duration(days: 1)),
      isDone: false,
      isFavorite: true,
    ),
    Activity(
      id: 'A007',
      title: 'Latihan Piano',
      category: 'Pribadi',
      description: 'Latihan rutin selama 1 jam.',
      deadline: now.add(const Duration(days: 2)),
      isDone: false,
    ),
    Activity(
      id: 'A008',
      title: 'Diskusi Proyek Kelompok Big Data',
      category: 'Kuliah',
      description: 'Membahas pembagian tugas proyek akhir.',
      deadline: now.add(const Duration(days: 5)),
      isDone: false,
    ),
    Activity(
      id: 'A009',
      title: 'Volunteer Kegiatan Sosial',
      category: 'Organisasi',
      description: 'Membantu acara bakti sosial fakultas.',
      deadline: now.subtract(const Duration(days: 2)),
      isDone: true,
    ),
    Activity(
      id: 'A010',
      title: 'Mengerjakan Tugas Komputasi Numerik',
      category: 'Tugas',
      description: 'Menyelesaikan soal metode Newton-Raphson.',
      deadline: now.add(const Duration(days: 3)),
      isDone: false,
    ),
  ];
}
