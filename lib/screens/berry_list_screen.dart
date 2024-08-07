import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/berry_model.dart';
import '../models/berry.dart';

class BerryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BerryModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Berries (Provider)'),
        actions: [
          Selector<BerryModel, int>(
            selector: (_, model) => model.favoriteCount,
            builder: (context, favoriteCount, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Favorites: $favoriteCount',
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
              onChanged: model.setSearchQuery,
            ),
          ),
          Expanded(
            child: Selector<BerryModel, BerryListState>(
              selector: (_, model) => BerryListState(
                isLoading: model.isLoading,
                error: model.error,
                filteredBerries: model.filteredBerries,
              ),
              builder: (context, state, child) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.error != null) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return ListView.builder(
                    itemCount: state.filteredBerries.length,
                    itemBuilder: (context, index) {
                      final berry = state.filteredBerries[index];
                      return ListTile(
                        title: Text(berry.name),
                        subtitle:
                            Text('Growth Time: ${berry.growthTime} hours'),
                        trailing: Selector<BerryModel, bool>(
                          selector: (_, model) =>
                              model.isBerryFavorite(berry.id),
                          builder: (context, isFavorite, child) {
                            return IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () => model.toggleFavorite(berry.id),
                            );
                          },
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

class BerryListState {
  final bool isLoading;
  final String? error;
  final List<Berry> filteredBerries;

  BerryListState({
    required this.isLoading,
    this.error,
    required this.filteredBerries,
  });
}
