import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Country {
  final String name;
  final String commonName;
  final String flagUri;

  Country({
    required this.name,
    required this.commonName,
    required this.flagUri,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['official'],
      commonName: json['name']['common'],
      flagUri: json['flags']['png'],
    );
  }
}

class CountryService {
  Future<List<Country>> getCountriesByRegion(String region) async {
    try {
      http.Response response = await http
          .get(Uri.parse('https://restcountries.com/v3.1/region/$region'));
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return [];
      }
      final List data = jsonDecode(response.body);
      return data
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Country>> getCountriesByCurrency(String currency) async {
    try {
      http.Response response = await http
          .get(Uri.parse('https://restcountries.com/v3.1/currency/$currency'));
      if (response.statusCode != 200) {
        debugPrint(response.body);
        return [];
      }
      final List data = jsonDecode(response.body);
      return data
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
