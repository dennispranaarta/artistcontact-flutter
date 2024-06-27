class Endpoints {
  static const String baseURL =
      "https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1";

  static const String baseURLLive = "http://10.0.2.2:5000";
  static const String news = "$baseURL/news";
  static const String datas = "$baseURLLive/api/datas";
  // ignore: constant_identifier_names
  static const String customerService =
      "$baseURLLive/api/customer-service/2215091057";
  static const String balance = "$baseURLLive/api/balance/2215091057";
  static const String spending = "$baseURLLive/api/spending/2215091057";

  static const String login = "$baseURLLive/api/v1/auth/login";
   static const String logout = "$baseURLLive/api/v1/auth/logout";
   static const String register = "$baseURLLive/api/v1/auth/register";
   static const String pelanggan = "$baseURLLive/api/v1/pelanggan";
   static const String pesanan = "$baseURLLive/api/v1/pesanan";
   static const String artist = "$baseURLLive/api/v1/artist";
    static const String user = "$baseURLLive/api/v1/user";
   static const String dataLogin = "$baseURLLive/api/v1/protected/data";
}