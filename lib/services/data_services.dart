// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/dto/CustomerService.dart';
import 'package:my_app/dto/artist.dart';
import 'package:my_app/dto/balances.dart';
import 'package:my_app/dto/dataLogin.dart';
import 'package:my_app/dto/datas.dart';
import 'dart:convert';

import 'package:my_app/dto/news.dart';
import 'package:my_app/dto/pesanan.dart';
import 'package:my_app/dto/profile.dart';
import 'package:my_app/dto/spending.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class DataService {


  static Future<List<Datas>> fetchDatas() async {
    final response = await http.get(Uri.parse(Endpoints.datas));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Datas.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  static Future<List<CustomerService>> fetchCustomerService() async {
    final response = await http.get(Uri.parse(Endpoints.customerService));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => CustomerService.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  static Future<void> deleteDatas(int id) async {
    await http.delete(Uri.parse('${Endpoints.datas}/$id'),
        headers: {'Content-type': 'aplication/json'});
  }

  static Future<void> updateDatas(String id, String title, String body) async {
    Map<String, String> data = {"id": id, "title": title, "body": body};
    String jsonData = jsonEncode(data);
    await http.put(Uri.parse('${Endpoints.datas}/$id'),
        body: jsonData, headers: {'Content-type': 'application/json'});
  }



  static Future<List<Balances>> fetchBalances() async {
    final response = await http.get(Uri.parse(Endpoints.balance));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Balances.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }
 static Future<List<Spendings>> fetchSpendings() async {
    final response = await http.get(Uri.parse(Endpoints.spending));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Spendings.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }
  static Future<http.Response> sendSpendingData(int spending) async {
  final url = Uri.parse(Endpoints.spending); // Replace with your endpoint
  final data = {'spending': spending};

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  return response;
  }

  // Post login with email and password
static Future<http.Response> sendLoginData(String username, String password) async {
  final url = Uri.parse(Endpoints.login); // Replace with your endpoint
  final data = {'username': username, 'password': password};

  try {
    final response = await http.post(
      url,
      body: data,
    );
    return response;
  } catch (e) {
    debugPrint("Error during http.post: $e");
    // Return a response with an appropriate error status code or message
    return http.Response('Error', 500);
  }
}



static Future<http.Response> logoutData() async {
  final url = Uri.parse(Endpoints.logout); // Replace with your endpoint
  final String? accessToken = 
    await SecureStorageUtil.storage.read(key: tokenStoreName);
  debugPrint("logout with $accessToken");

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  return response;
}

static Future<dataLogin> fetchProfile(String? accessToken) async {
    accessToken ??= await SecureStorageUtil.storage.read(key: tokenStoreName);

    final response = await http.get(
      Uri.parse(Endpoints.dataLogin),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    debugPrint('Profile response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }

      try {
        return dataLogin.fromJson(jsonResponse);
      } catch (e) {
        throw Exception('Failed to parse Profile: $e');
      }
    } else {
      // Handle error
      throw Exception(
          'Failed to load Profile with status code: ${response.statusCode}');
    }
  }

// Send Data Order

static Future<http.Response> sendCreateOrderData(int idUser, String idArtist, String tanggalPembayaran, String tanggalTampil) async {
    final url = Uri.parse('${Endpoints.pesanan}/create');
  final data = {
      'id_user': idUser.toString(),
      'id_artist': idArtist,
      'tanggal_pembayaran': tanggalPembayaran,
      'tanggal_tampil': tanggalTampil
    };
    

    final response = await http.post(
      url,
      body: data,
    );

    return response;
  }

static Future<List<Pesanan>> getOrders() async {
    final url = Uri.parse('${Endpoints.pesanan}/read');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['datas'] == null) {
          throw Exception('Datas key is missing or null');
        }
        List<dynamic> ordersJson = data['datas'];
        return ordersJson.map((json) => Pesanan.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Failed to parse orders');
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }


static Future<void> updateOrder(int idPesanan, String tanggalPembayaran, String tanggalTampil, String status) async {
  final url = Uri.parse('${Endpoints.pesanan}/update/$idPesanan');
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'tanggal_pembayaran': tanggalPembayaran,
      'tanggal_tampil': tanggalTampil,
      'status': status,
    },
  );

  if (response.statusCode != 200) {
    final errorData = json.decode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to update order');
  }
}




static Future<void> deleteOrder(int idPesanan) async {
    final url = Uri.parse('${Endpoints.pesanan}/delete/$idPesanan');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to delete order');
    }
  }

//Send data Artist
static String baseURLLive = '${Endpoints.artist}/create';

  Future<void> createArtist(Map<String, String> data) async {
    try {
      var response = await http.post(Uri.parse('${Endpoints.artist}/create'), body: data);
      if (response.statusCode == 200) {
        // Handle success
      } else {
        // Handle other status codes
      }
    } catch (e) {
      // Handle other errors
    }
  }



  Future<List<Pesanan>> fetchPesananByUser(int idUser) async {
    String url = '${Endpoints.pesanan}/read_by_user?id_user=$idUser';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['datas'];
        return data.map((item) => Pesanan.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }



Future<UserDTO?> fetchUserDataById(int idUser) async {
    final response = await http.get(
      Uri.parse('${Endpoints.user}/read_by_user?id_user=$idUser'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['datas'] != null && data['datas'].isNotEmpty) {
        return UserDTO.fromJson(data['datas'][0]);
      }
    } else {
      throw Exception('Failed to load user data');
    }
    return null;
  }
}








