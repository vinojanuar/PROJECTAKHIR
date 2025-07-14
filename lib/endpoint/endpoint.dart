class Endpoint {
  static const String baseUrl = "https://appabsensi.mobileprojp.com";
  static const String baseUrlApi = "$baseUrl/api";
  static const String register = "$baseUrlApi/register";
  static const String login = "$baseUrlApi/login";
  static const String batch = "$baseUrlApi/batches";
  static const String training = "$baseUrlApi/trainings";
  static const String checkIn = "$baseUrlApi/absen/check-in";
  static const String checkOut = "$baseUrlApi/absen/check-out";
  static const String history = "$baseUrlApi/absen/history";
  static String absenToday(String date) =>
      "$baseUrlApi/absen/today?attendance_date=$date";
  static const String absenStatus = "$baseUrlApi/absen/stats";
  static const String Izin = "$baseUrlApi/izin";
  static const String profile = "$baseUrlApi/profile";
  static const String addPhoto = "$baseUrlApi/profile/photo";
}
