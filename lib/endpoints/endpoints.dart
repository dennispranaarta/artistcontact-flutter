class Endpoints {
  static const String baseURL =
      "https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1";

  static String baseURLLive = "http://127.0.0.1:4040";
static void updateBaseURL(String url) {
    baseURLLive = url;
  }


  static String get news => "$baseURL/news";
  static String get datas => "$baseURLLive/api/datas";
  // ignore: constant_identifier_names
  static String get customerService =>
      "$baseURLLive/api/customer-service/2215091057";
  static String get balance => "$baseURLLive/api/balance/2215091057";
  static String get spending => "$baseURLLive/api/spending/2215091057";

  static String get login => "$baseURLLive/api/v1/auth/login";
   static String get logout => "$baseURLLive/api/v1/auth/logout";
   static String get register => "$baseURLLive/api/v1/auth/register";
   static String get pelanggan => "$baseURLLive/api/v1/pelanggan";
   static String get pesanan => "$baseURLLive/api/v1/pesanan";
   static String get artist => "$baseURLLive/api/v1/artist";
    static String get user => "$baseURLLive/api/v1/user";
    static String get booking => "$baseURLLive/api/v1/booking";
   static String get dataLogin => "$baseURLLive/api/v1/protected/data";
}