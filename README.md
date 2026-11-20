# The Closet Club (TCC) Mobile

**Aplikasi Mobile Komunitas Fashion untuk Mendukung Gerakan Slow Fashion dan Conscious Shopping.**

The Closet Club (TCC) Mobile adalah versi *mobile* dari platform media sosial dan barter busana The Closet Club yang menghubungkan para pecinta gaya hidup berkelanjutan (*sustainable living*). Aplikasi ini dibangun dengan Flutter dan terhubung ke situs web TCC dari Proyek Tengah Semester melalui *web service* Django REST Framework, sehingga pertukaran pakaian (*swap/barter*), lemari digital (*digital closet*), inspirasi *outfit feed*, dan komunikasi langsung dapat diakses langsung dari ponsel.

[**Situs Web The Closet Club**](https://faiz-yusuf51-the-closet-club.pws.cs.ui.ac.id) · [**Desain Figma**](https://www.figma.com/design/36o8v7Kpihl96GwMuIg4Of/TCC?node-id=333-2249&t=ZflLifSc8F03UHF3-1)

---

## Daftar Isi

- [Gambaran Umum Proyek](#gambaran-umum-proyek)
- [Fitur Utama](#fitur-utama)
- [Peran Pengguna](#peran-pengguna)
- [Alur Integrasi Data Mobile dan Web](#alur-integrasi-data-mobile-dan-web)
- [Teknologi dan API](#teknologi-dan-api)
- [Panduan Instalasi](#panduan-instalasi)
- [Modul Proyek dan Anggota Tim](#modul-proyek-dan-anggota-tim)
- [Desain Proyek](#desain-proyek)
- [Deployment](#deployment)
- [AI Disclosure](#ai-disclosure)

---

## Gambaran Umum Proyek

Industri *fast fashion* mendorong kebiasaan konsumtif yang menghasilkan jutaan ton limbah pakaian setiap tahunnya. Banyak pakaian berkualitas baik berakhir menumpuk di lemari dan jarang terpakai.

**The Closet Club (TCC)** hadir sebagai solusi *circular fashion* berbasis komunitas. Melalui aplikasi *mobile* ini, pengguna dapat:
1. Membagikan dan menjelajahi inspirasi *outfit* harian pada feed sosial media.
2. Mengatalogkan koleksi busana pribadi ke dalam *digital closet*.
3. Menandai pakaian tertentu untuk dibarter (*swap*) kepada pengguna lain.
4. Berkomunikasi langsung melalui *chat* untuk membahas detail pakaian dan menyepakati serah terima.

Seluruh data aplikasi tetap tersimpan di situs web Django dari Proyek Tengah Semester. Aplikasi Flutter tidak memiliki data statis dan hanya mengambil serta mengirim data melalui *endpoint* Django REST Framework.

---

## Fitur Utama

### 1. Login, Profile, & Reputation (`accounts`)
Mengelola sistem identitas akun pengguna, keamanan sesi, penanda verifikasi resmi, serta penilaian kredibilitas berbasis transaksi.
- Registrasi, login/logout, dan profil pengguna yang terhubung ke sesi Django.
- Badge verifikasi akun dan rata-rata rating ulasan dari transaksi swap yang telah selesai.

### 2. Feed & Clothing Post (`feed`)
Kanal interaksi sosial utama yang menampilkan inspirasi busana harian dan pakaian yang tersedia untuk pertukaran.
- Menjelajahi katalog foto *outfit* dan busana dengan kartu pakaian yang informatif.
- Fitur pencarian dan filter pakaian berdasarkan kategori, ukuran, atau status ketersediaan.

### 3. Lemari Digital (*My Closet*) (`closet`)
Ruang personal bagi setiap pengguna terdaftar untuk menginventarisasi pakaian mereka.
- Operasi CRUD pakaian dengan foto dan deskripsi kondisi.
- Pengaturan status pakaian: koleksi pribadi, tersedia untuk barter, atau sudah terbarter.

### 4. Percakapan Langsung (*Chat*) (`chat`)
Sistem komunikasi privat antarpengguna untuk membahas detail pakaian sebelum pertukaran disepakati. Pesan diperbarui melalui polling berkala pada ruang chat, sama seperti pada versi web.
- Daftar riwayat percakapan (*conversation list*) lengkap dengan pratinjau pesan, waktu, jumlah pesan belum dibaca, dan badge verifikasi lawan bicara.
- Ruang obrolan (*chat room*) dengan pesan teks, balasan pesan, penanda pesan terbaca, serta penanda pesan yang telah diedit.
- Penanganan status blokir antarpengguna sehingga pesan tidak dapat dikirim ke pengguna yang saling memblokir.
- Rencana pengembangan hingga pengumpulan akhir: memulai percakapan baru, edit dan hapus pesan, blokir dan laporan, berbagi lokasi, serta lampiran foto dan dokumen.

### 5. Barter & Pertukaran (*Swap / Barter*) (`swap`)
Manajemen siklus hidup transaksi barter busana dari pengajuan hingga selesai.
- Alur transaksi terstruktur: pemilihan item yang diinginkan → penawaran item penukar → status permintaan (*Pending*, *Counter offered*, *Accepted*, *In progress*, *Declined*, *Cancelled*, *Completed*).

---

## Peran Pengguna

| Peran | Hak Akses | Aksi yang Diizinkan | Aksi yang Dibatasi |
|---|---|---|---|
| **Tamu (*Guest / Anonymous*)** | *Read-only* pada konten publik | Menjelajahi *feed outfit*, melihat lemari digital publik pengguna lain, menggunakan pencarian dan filter barang. | Mengunggah pakaian/outfit, mengakses menu obrolan (*chat*), mengajukan barter pakaian, memberikan ulasan/rating, mengedit profil. |
| **Pengguna Terdaftar (*Registered User*)** | Hak penuh (*Authenticated*) | Seluruh akses tamu, mengelola *My Closet*, memposting ke *feed*, mengirim pesan via *chat*, mengajukan permohonan *swap*, mengajukan verifikasi akun, serta memberi ulasan transaksi. | Mengubah status verifikasi secara mandiri tanpa persetujuan admin panel. |

---

## Alur Integrasi Data Mobile dan Web

Data aplikasi tetap tersimpan pada basis data situs web Django di PWS dari Proyek Tengah Semester. Aplikasi Flutter mengaksesnya melalui *web service* yang dibangun dengan **Django REST Framework** di dalam proyek Django yang sama.

1. **Login:** Pengguna masuk dari aplikasi, lalu Django membuat sesi dan mengirimkan *session cookie*.
2. **Penyimpanan Sesi:** Objek `CookieRequest` dari paket `pbp_django_auth` menyimpan cookie tersebut dan menyertakannya pada setiap permintaan berikutnya. Objek ini dibagikan ke seluruh modul melalui `Provider`.
3. **Pemanggilan Asinkron:** Setiap modul memanggil *endpoint* DRF miliknya menggunakan `async` dan `await`.
4. **Pemrosesan di Django:** Django memvalidasi sesi, membaca atau menulis data pada basis data yang sama dengan situs web, lalu membalas dalam format JSON.
5. **Penampilan Data:** Aplikasi mengubah JSON menjadi model Dart dan menampilkannya melalui *widget*.

Karena situs web dan aplikasi *mobile* memakai basis data yang sama, pesan yang dikirim dari satu sisi langsung terlihat di sisi lainnya. Autentikasi *endpoint* memakai `CsrfExemptSessionAuthentication` karena klien *mobile* tidak memiliki token CSRF seperti halaman web.

### Daftar Endpoint Modul Chat

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/chat/api/conversations/` | Daftar percakapan milik pengguna yang sedang login. |
| GET | `/chat/api/conversations/<id>/messages/` | Informasi percakapan beserta pesan terbaru. |
| POST | `/chat/api/conversations/<id>/messages/` | Mengirim pesan teks, dengan opsi membalas pesan tertentu. |

Seluruh *endpoint* hanya dapat diakses setelah login. Pengguna yang bukan peserta percakapan menerima respons 404, dan pengguna yang saling memblokir menerima respons 403 saat mengirim pesan.

### Daftar Endpoint Modul Accounts

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/accounts/users/` | Daftar seluruh pengguna yang terdaftar, diurutkan berdasarkan username. |
| GET, PUT, PATCH | `/api/accounts/profile/` | Melihat dan memperbarui profil pengguna yang sedang login (wajib login). |
| GET | `/api/accounts/users/<username>/` | Detail profil publik pengguna berdasarkan username. |
| GET | `/api/accounts/users/<username>/reviews/` | Daftar ulasan (review) yang diterima oleh pengguna tertentu, terbaru lebih dulu. |
| GET | `/api/accounts/verification/` | Melihat status pengajuan verifikasi akun pengguna yang sedang login (wajib login). |

Endpoint `/api/accounts/profile/` dan `/api/accounts/verification/` hanya dapat diakses setelah login. Endpoint autentikasi (login, register, logout), pengajuan verifikasi, hapus akun, serta tambah dan ubah ulasan menyusul sebelum pengumpulan akhir.

---

### Daftar Endpoint Modul Closet

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | /closet/api/items/ | Daftar pakaian milik pengguna yang sedang login, terbaru lebih dulu. |
| GET | /closet/api/items/<id>/ | Detail satu pakaian milik pengguna (milik orang lain menerima 404). |

Seluruh *endpoint* hanya dapat diakses setelah login. Endpoint tambah, ubah, hapus, dan ubah status pakaian menyusul sebelum pengumpulan akhir.

---

## Teknologi dan API

### Teknologi yang Digunakan (*Technology Stack*)

- **Aplikasi Mobile:** Flutter 3.50 dan Dart 3.14.
- **Antarmuka:** Widget Material melalui paket `material_ui`, dengan tipografi Gloock dan Work Sans melalui `google_fonts`.
- **State & Jaringan:** `provider` untuk berbagi sesi, `pbp_django_auth` (`CookieRequest`) untuk autentikasi berbasis cookie, dan `http`.
- **Backend:** Python dan Django Framework (v5.x) dari Proyek Tengah Semester, ditambah Django REST Framework untuk *web service*.
- **Database:** PostgreSQL pada PWS (*production*) dan SQLite untuk pengembangan lokal.

---

## Panduan Instalasi

Ikuti petunjuk di bawah ini untuk menjalankan TCC Mobile pada komputer lokal Anda.

### Prasyarat
- Flutter SDK 3.50 atau versi yang lebih baru.
- Git.
- Android Studio dengan Android Emulator, atau perangkat Android fisik.

### Langkah-langkah Menjalankan Aplikasi

**1. Clone repositori Git**
```bash
git clone <URL_REPOSITORY_TCC_MOBILE>
cd the_closet_club_mobile
```

**2. Pasang seluruh dependensi proyek**
```bash
flutter pub get
```

**3. Atur alamat backend**

Buka `lib/core/api_config.dart`. Secara bawaan aplikasi memakai backend PWS (`pwsBaseUrl`). Untuk memakai Django lokal pada Android Emulator, gunakan alamat `http://10.0.2.2:8000`.

**4. Jalankan aplikasi pada emulator**
```bash
flutter emulators --launch <EMULATOR_ID>
flutter run
```

---

## Modul Proyek dan Anggota Tim

### Pembagian Modul Utama

| Modul | Penanggung Jawab | Deskripsi Tanggung Jawab |
|---|---|---|
| **Login, Profile, & Reputation** (`accounts`) | Ria Lavenia Kharissa — 2506543905 | Autentikasi pengguna, profil, pengajuan verifikasi, serta ulasan reputasi pada aplikasi *mobile*. |
| **Feed & Clothing Post** (`feed`) | Nauval Adiva Daneshwara — 2506623074 | Katalog busana umum, filter/search item, serta interaksi minat item. |
| **My Closet** (`closet`) | Nadya Alyssa Azzahra — 2506599270 | Manajemen inventaris pakaian pribadi pengguna (CRUD pakaian, status ketersediaan barter). |
| **Chat** (`chat`) | Faiz Yusuf Elriki — 2506607921 | Sistem percakapan privat antarpengguna sebelum transaksi tukar, dengan pembaruan pesan melalui polling. |
| **Swap / Barter** (`swap`) | Naila Husna Teguh Suasono — 2506620444 | Alur pengajuan tukar busana, negosiasi barter barang, dan penentuan kesepakatan akhir. |

### Modul Bersama / Integrasi Global

| Komponen Bersama | Kontributor | Deskripsi Implementasi |
|---|---|---|
| **Kerangka Aplikasi & Navigasi** | Faiz Yusuf Elriki | Struktur folder per modul, navigasi bawah (*bottom navigation*), tema warna dan tipografi TCC (`app_theme.dart`), serta penyedia sesi `CookieRequest` yang dipakai bersama. |

---

## Desain Proyek

Referensi desain purwarupa (*wireframe* dan *high-fidelity mockups*) aplikasi The Closet Club tersedia pada tautan Figma berikut:

[**Buka Desain The Closet Club di Figma**](https://www.figma.com/design/36o8v7Kpihl96GwMuIg4Of/TCC?node-id=333-2249&t=ZflLifSc8F03UHF3-1)

---

## Deployment

Backend The Closet Club telah dideploy dan dapat diakses publik melalui Platform Web Service (PWS) Fasilkom UI:

**Tautan Situs Web Aktif:** [https://faiz-yusuf51-the-closet-club.pws.cs.ui.ac.id](https://faiz-yusuf51-the-closet-club.pws.cs.ui.ac.id)

**Tautan APK:** Akan ditambahkan setelah Checkpoint 1.