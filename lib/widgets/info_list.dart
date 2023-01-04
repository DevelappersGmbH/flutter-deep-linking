import 'package:country_deep_linking/services/country.dart';
import 'package:flutter/material.dart';

class InfoList extends StatelessWidget {
  final List<Country> countries;
  const InfoList({required this.countries, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(countries[index].commonName),
          subtitle: Text(countries[index].name),
          leading: Image.network(
            countries[index].flagUri,
            width: 75,
          ),
        );
      },
    );
  }
}
