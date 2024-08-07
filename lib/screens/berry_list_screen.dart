import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/berry_model.dart';

class BerryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berries (Provider)'),
        actions: [
          Consumer<BerryModel>(
            builder: (context, model, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Favorites: ${model.favoriteCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search berries...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                Provider.of<BerryModel>(context, listen: false)
                    .setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<BerryModel>(
              builder: (context, model, child) {
                if (model.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (model.error != null) {
                  return Center(child: Text('Error: ${model.error}'));
                } else {
                  return ListView.builder(
                    itemCount: model.filteredBerries.length,
                    itemBuilder: (context, index) {
                      final berry = model.filteredBerries[index];
                      return ListTile(
                        title: Text(berry.name),
                        subtitle:
                            Text('Growth Time: ${berry.growthTime} hours'),
                        trailing: IconButton(
                          icon: Icon(
                            model.isBerryFavorite(berry.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: model.isBerryFavorite(berry.id)
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () => model.toggleFavorite(berry.id),
                        ),
                        onTap: () =>
                            context.push('/berry-details/${berry.name}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
