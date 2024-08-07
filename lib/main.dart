import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'models/berry_model.dart';
import 'services/api_service.dart';
import 'screens/berry_list_screen.dart';
import 'screens/berry_details_screen.dart';

void main() {
  runApp(BerryProviderDemo());
}

class BerryProviderDemo extends StatelessWidget {
  final ApiService apiService = ApiService();

  BerryProviderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BerryModel(apiService),
      child: MaterialApp.router(
        title: 'Berry App (Provider)',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: _router,
      ),
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BerryListScreen(),
      ),
      GoRoute(
        path: '/berry-details/:name',
        builder: (context, state) {
          final berryName = state.pathParameters['name']!;
          return BerryDetailsScreen(berryName: berryName);
        },
      ),
    ],
  );
}
