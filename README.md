# Study Planner — Tugas Individu Pemrograman Mobile

Aplikasi pencatat aktivitas belajar pribadi. Dibuat dengan Flutter +
Provider, sesuai ketentuan Bagian III (Tugas & Target UTS).

## Buat Project Flutter Baru

1. Buat project Flutter baru:
   ```
   flutter create study_planner
   cd study_planner
   ```
2. Jalankan:
   ```
   flutter pub get
   flutter run
   ```

## Struktur layar (6 layar sesuai ketentuan)

1. **Beranda** (`home_screen.dart`) — ringkasan jumlah aktivitas,
   selesai, favorit, dan 3 aktivitas terbaru.
2. **Daftar Aktivitas** (`activity_list_screen.dart`) — pencarian +
   filter kategori + filter status yang bisa digabung, tombol tambah.
3. **Detail** (`activity_detail_screen.dart`) — data lengkap satu
   aktivitas, tandai selesai, edit, hapus (dengan konfirmasi).
4. **Tambah/Edit** (`activity_form_screen.dart`) — satu form dipakai
   ulang untuk dua mode, dengan validasi input.
5. **Favorit** (`favorite_screen.dart`) — daftar aktivitas yang
   ditandai favorit.
6. **Profil** (`profile_screen.dart`) — data mahasiswa pemilik aplikasi
   + ringkasan statistik aktivitas.

Komponen kartu (`widgets/activity_card.dart`) dipakai ulang di layar
Beranda, Daftar Aktivitas, dan Favorit.

## Pemilik state dan alur data (contoh: fitur Favorit)

`ActivityProvider` (di `providers/activity_provider.dart`) adalah
satu-satunya pemilik data aktivitas — semua layar membaca dan mengubah
data lewat provider ini, tidak ada state duplikat di masing-masing
layar.

Alur saat tombol favorit (ikon hati) ditekan di `ActivityCard`:

1. `ActivityCard.onFavoriteTap` dipanggil dari layar mana pun kartu itu
   ditampilkan (Beranda, Daftar Aktivitas, atau Favorit).
2. Layar memanggil `context.read<ActivityProvider>().toggleFavorite(id)`.
3. Di dalam provider, item dengan `id` yang cocok di-*copy* dengan nilai
   `isFavorite` dibalik, lalu `notifyListeners()` dipanggil.
4. Semua widget yang memakai `context.watch<ActivityProvider>()`
   (Beranda, Daftar Aktivitas, Detail, Favorit, Profil) otomatis
   membangun ulang tampilannya dengan data terbaru.
5. Karena semua layar membaca dari sumber yang sama, ikon hati,
   jumlah favorit di Beranda/Profil, dan isi layar Favorit selalu
   konsisten satu sama lain tanpa perlu sinkronisasi manual.

Pola yang sama berlaku untuk tambah, edit, hapus, dan tandai selesai —
semua mutasi lewat method di `ActivityProvider`, semua layar membaca
lewat `context.watch`/`context.read`.

## 12 Skenario uji

| No | Skenario | Input | Ekspektasi | Hasil Aktual | Status |
|----|----------|-------|------------|---------------|--------|
| 1 | Tambah aktivitas valid | Judul "Belajar Flutter", kategori Tugas, deskripsi diisi, deadline dipilih | Aktivitas baru muncul di Daftar Aktivitas | Aktivitas "Belajar Flutter" berhasil muncul di Daftar Aktivitas | Berhasil |
| 2 | Tambah aktivitas judul kosong | Judul dikosongkan, tekan Tambah | Muncul pesan error "Judul wajib diisi", data tidak tersimpan | Muncul pesan "Judul wajib diisi" dan data tidak tersimpan | Berhasil |
| 3 | Tambah aktivitas judul terlalu pendek | Judul "ab" | Muncul pesan error "Judul minimal 3 karakter" | Muncul pesan "Judul minimal 3 karakter" | Berhasil |
| 4 | Batal saat tambah | Isi form lalu tekan Batal | Kembali ke Daftar Aktivitas, tidak ada aktivitas baru ditambahkan | Tidak ada aktivitas baru yang ditambahkan | Berhasil |
| 5 | Edit aktivitas | Buka salah satu aktivitas, ubah judul, tekan Simpan | Judul berubah di Detail dan Daftar Aktivitas, ID tetap sama | Judul berubah baik di Detail dan Daftar Aktivitas | Berhasil |
| 6 | Batal saat edit | Buka aktivitas, ubah judul, tekan Batal | Judul aktivitas tidak berubah (data lama tetap) | Judul aktivitas tidak berubah | Berhasil |
| 7 | Hapus aktivitas — konfirmasi Ya | Tekan Hapus di Detail, tekan Hapus di dialog | Aktivitas hilang dari Daftar Aktivitas dan Beranda | Aktivitas terhapus dari Daftar Aktivitas | Berhasil |
| 8 | Hapus aktivitas — konfirmasi Batal | Tekan Hapus di Detail, tekan Batal di dialog | Aktivitas tetap ada, tidak terhapus | Aktivitas tetap ada di Daftar Aktivitas | Berhasil |
| 9 | Pencarian | Ketik sebagian judul aktivitas di kolom cari | Hanya aktivitas yang judulnya cocok yang tampil | Sesuai Ekspektasi | Berhasil |
| 10 | Filter kategori saja | Pilih kategori "Kuliah" | Hanya aktivitas kategori Kuliah yang tampil | Sesuai Ekspektasi | Berhasil |
| 11 | Pencarian + filter digabung | Ketik kata kunci sekaligus pilih kategori dan status | Hasil hanya aktivitas yang cocok dengan ketiga kriteria sekaligus | Sesuai Ekspektasi | Berhasil |
| 12 | Tandai favorit dari beberapa layar | Tandai favorit di Daftar Aktivitas dan Favorit | Status favorit dan jumlah favorit konsisten di semua layar | Status favorit dan jumlah favorit ada di Daftar Aktivitas dan Favorit | Berhasil |

## Checklist paket pengumpulan

- [ ] Source Flutter (folder `lib/` + `pubspec.yaml`) beserta README ini
- [ ] Video 4–6 menit: demo tambah, edit, batal, hapus, filter, favorit
- [ ] Tabel 12 skenario uji di atas, kolom Hasil Aktual & Status sudah
      diisi
- [ ] Screenshot minimal 6 layar (Beranda, Daftar Aktivitas, Detail,
      Tambah/Edit, Favorit, Profil)
- [ ] Screenshot minimal 3 kondisi error/kosong, contoh: validasi judul
      kosong, hasil pencarian tidak ditemukan, layar Favorit saat belum
      ada favorit
