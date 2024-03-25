import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: CountryScreen(countryService: CountryService(client.value)),
      ),
    );
  }
}

class CountryScreen extends StatelessWidget {
  final CountryService countryService;

  const CountryScreen({super.key, required this.countryService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries and Capitals'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: countryService.getAllCountriesAndCapitals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, String>> countriesAndCapitals =
                snapshot.data!;
            return ListView.builder(
              itemCount: countriesAndCapitals.length,
              itemBuilder: (context, index) {
                final country = countriesAndCapitals[index];
                return ListTile(
                  title: Text(country['name'] ?? 'N/A'),
                  subtitle: Text(country['capital'] ?? 'N/A'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final Map<String, String> uzCountry =
                  await countryService.getUZCountry();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Uzbekistan Country'),
                    content: Text('Name: ${uzCountry['name']}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Text('Get Uzbekistan'),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () async {
              final Map<String, String> tnCountry =
                  await countryService.getTNCountry();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Tunisia Country'),
                    content: Text('Name: ${tnCountry['name']}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Text('Get Tunisia'),
          ),
        ],
      ),
    );
  }
}

class CountryService {
  final GraphQLClient client;

  CountryService(this.client);

  Future<List<Map<String, String>>> getAllCountriesAndCapitals() async {
    const String getAllCountriesQuery = r'''
      query getAllCountries {
        countries {
          name
          capital
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getAllCountriesQuery),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('GraphQL Error: ${result.exception.toString()}');
    }

    final List<dynamic> countryData = result.data!['countries'];
    return countryData
        .map<Map<String, String>>((country) => {
              'name': country['name'],
              'capital': country['capital'] ?? 'N/A',
            })
        .toList();
  }

  Future<Map<String, String>> getUZCountry() async {
    const String getUZCountryQuery = r'''
      query getUZCountry {
        country(code: "UZ") {
          name
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getUZCountryQuery),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('GraphQL Error: ${result.exception.toString()}');
    }

    return {
      'name': result.data!['country']['name'],
    };
  }

  Future<Map<String, String>> getTNCountry() async {
    const String getTNCountryQuery = r'''
      query getTNCountry {
        country(code: "TN") {
          name
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getTNCountryQuery),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('GraphQL Error: ${result.exception.toString()}');
    }

    return {
      'name': result.data!['country']['name'],
    };
  }
}
