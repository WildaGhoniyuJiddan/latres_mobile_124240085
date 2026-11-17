# Latihan Responsi Mobile Aplikasi Harry Potter

Aplikasi Flutter sederhana untuk latihan responsi Praktikum Teknologi dan Pemrograman Mobile.

## Fitur

1. **Login**  username/password hardcoded, session disimpan di SharedPreferences, snackbar sukses/gagal
2. **Characters**  data karakter Harry Potter dari API, tap untuk lihat detail (semua property)
3. **Spells**  data spell dari API, tombol favorite (disimpan di Hive), snackbar add/remove
4. **Favorite Spell**  daftar spell favorite, hapus dengan notifikasi (local notification)
5. **Logout**  ada di AppBar halaman Characters dan Spells

## Kredensial Login

- Username: `username`
- Password: `password`

## API

- Characters: https://potterapi-fedeperin.vercel.app/en/characters
- Spells: https://potterapi-fedeperin.vercel.app/en/spells

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Package yang dipakai

- `http` — ambil data API
- `shared_preferences` — simpan session login
- `hive` + `hive_flutter` — simpan spell favorite
- `flutter_local_notifications` — notifikasi hapus favorite
