import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/berry_model.dart';
import '../models/berry.dart';

class BerryDetailsScreen extends StatelessWidget {
  final String berryName;

  const BerryDetailsScreen({Key? key, required this.berryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berry Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<BerryModel>(
        builder: (context, model, child) {
          return FutureBuilder<Berry>(
            future: model.getBerryDetails(berryName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final berry = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${berry.name}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('ID: ${berry.id}'),
                      Text('Growth Time: ${berry.growthTime} hours'),
                      Text('Max Harvest: ${berry.maxHarvest}'),
                      Text('Size: ${berry.size} mm'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Refresh berry details
                          model.getBerryDetails(berryName);
                        },
                        child: Text('Refresh Berry Details'),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('No data available'));
              }
            },
          );
        },
      ),
    );
  }
}
