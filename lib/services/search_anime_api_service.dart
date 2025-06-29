import 'api_base_service.dart';

class SearchAnimeService extends BaseAnimeService {
  Future<Map<String, dynamic>> fetchInitialAnimes(String query) async {
    try {
      final url =
          'https://api.myanimelist.net/v2/anime?q=$query&fields=alternative_titles,main_picture,genres';

      return await fetchAnimesWithPaging(url);
    } catch (e) {
      rethrow;
    }
  }
}
