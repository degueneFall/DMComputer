import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static Future<List<int>> getFavoriteProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favoriteProductIds')?.map(int.parse).toList() ?? [];
  }

  static Future<void> addFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = await getFavoriteProductIds();
    favoriteIds.add(productId);
    prefs.setStringList('favoriteProductIds', favoriteIds.map((id) => id.toString()).toList());
  }

  static Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = await getFavoriteProductIds();
    favoriteIds.remove(productId);
    prefs.setStringList('favoriteProductIds', favoriteIds.map((id) => id.toString()).toList());
  }
}
