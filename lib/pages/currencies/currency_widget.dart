import 'package:country_deep_linking/services/country.dart';
import 'package:flutter/material.dart';

import '../../widgets/info_list.dart';

class CurrencyWidget extends StatelessWidget {
  final String currency;
  const CurrencyWidget(this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CountryService().getCountriesByCurrency(currency),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InfoList(countries: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
