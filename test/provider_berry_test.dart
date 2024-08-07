import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:berry_provider/models/berry_model.dart';
import 'package:berry_provider/models/berry.dart';
import 'package:berry_provider/services/api_service.dart';

@GenerateMocks([ApiService])
import 'provider_berry_test.mocks.dart';

void main() {
  late BerryModel berryModel;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    berryModel = BerryModel(mockApiService);
  });

  final List<Berry> testBerries = [
    Berry(id: 1, name: 'Cheri', growthTime: 3, maxHarvest: 5, size: 20),
    Berry(id: 2, name: 'Chesto', growthTime: 3, maxHarvest: 5, size: 80),
    Berry(id: 3, name: 'Pecha', growthTime: 3, maxHarvest: 5, size: 40),
    Berry(id: 4, name: 'Rawst', growthTime: 3, maxHarvest: 5, size: 32),
    Berry(id: 5, name: 'Aspear', growthTime: 3, maxHarvest: 5, size: 50),
  ];

  test('BerryModel initializes with empty lists and sets', () {
    expect(berryModel.berries, isEmpty);
    expect(berryModel.filteredBerries, isEmpty);
    expect(berryModel.favoriteCount, 0);
  });

  test('BerryModel fetches berries successfully', () async {
    when(mockApiService.getBerries()).thenAnswer((_) async => testBerries);
    await berryModel.fetchBerries();
    expect(berryModel.berries.length, 5);
    expect(berryModel.filteredBerries.length, 5);
  });

  test('BerryModel filters berries when search query is set', () async {
    when(mockApiService.getBerries()).thenAnswer((_) async => testBerries);
    when(mockApiService.searchBerries(any)).thenAnswer((invocation) async {
      final String query = invocation.positionalArguments[0] as String;
      return testBerries
          .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    await berryModel.fetchBerries();
    berryModel.setSearchQuery('che');

    expect(berryModel.filteredBerries.length, 2);
    expect(berryModel.filteredBerries.map((b) => b.name).toList(),
        ['Cheri', 'Chesto']);
  });

  test('BerryModel toggles favorites correctly', () {
    berryModel.toggleFavorite(1);
    expect(berryModel.favoriteCount, 1);
    expect(berryModel.isBerryFavorite(1), true);

    berryModel.toggleFavorite(1);
    expect(berryModel.favoriteCount, 0);
    expect(berryModel.isBerryFavorite(1), false);
  });

  test('BerryModel handles errors during berry fetching', () async {
    when(mockApiService.getBerries()).thenThrow(Exception('Network error'));

    await berryModel.fetchBerries();

    expect(berryModel.error, isNotNull);
    expect(berryModel.isLoading, false);
  });
}
