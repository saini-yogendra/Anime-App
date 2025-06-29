
import 'api_base_service.dart';

class ShonenAnimeService extends BaseAnimeService {
  Future<Map<String, dynamic>> fetchShonenAnimes() async {
    try {
      const url = 'https://api.myanimelist.net/v2/anime?genres=27&q=shounen';

      return await fetchAnimesWithPaging(url);
    } catch (e) {
      rethrow;
    }
  }
}
