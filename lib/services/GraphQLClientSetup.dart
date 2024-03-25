import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; // Import the graphql_flutter package

class GraphQLClientSetup {
  static HttpLink httpLink = HttpLink(
    'https://countries.trevorblades.com/graphql',
  );

  static ValueNotifier<GraphQLClient> initializeClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );
    return client;
  }

}
