class ApiConfig {
  // Backend Django yang sudah di-deploy di PWS (ganti kalau URL kelompok beda).
  static const String pwsBaseUrl =
      'https://faiz-yusuf51-the-closet-club.pws.cs.ui.ac.id';

  // Django lokal, untuk run di Chrome.
  static const String localBaseUrl = 'http://localhost:8000';

  // Ganti ke localBaseUrl kalau mau develop dengan Django lokal.
  static const String baseUrl = pwsBaseUrl;
}